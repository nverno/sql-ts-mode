;;; sql-ts-mode.el --- Tree-sitter support for SQL -*- lexical-binding: t; -*-

;; Author: Noah Peart <noah.v.peart@gmail.com>
;; URL: https://github.com/nverno/sql-ts-mode
;; Version: 0.0.1
;; Package-Requires: ((emacs "29.1"))
;; Created: 12 April 2024
;; Keywords: sql languages tree-sitter

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; This packages provides a major mode for SQL using tree-sitter.
;;
;; The required tree-sitter parser is available from
;; https://github.com/DerekStride/tree-sitter-sql.
;;
;;; Code:

(require 'treesit)
(require 'sql)                          ; `sql-mode-syntax-table'


(defcustom sql-ts-mode-indent-offset 2
  "Number of spaces for each indentation step in `sql-ts-mode'."
  :type 'integer
  :safe 'integerp
  :group 'SQL)

(defcustom sql-ts-mode-statement-indent-offset 1
  "Number of spaces to indent keywords in statements."
  :type 'integer
  :safe 'integerp
  :group 'SQL)

(defcustom sql-ts-mode-transaction-indent-offset 1
  "Number of spaces to indent statements in transactions."
  :type 'integer
  :safe 'integerp
  :group 'SQL)

(defcustom sql-ts-mode-lineup-terms t
  "Non-nil to lineup terms with their first sibling."
  :type 'boolean
  :safe 'booleanp
  :group 'SQL)

(defface sql-ts-mode-relation-name-face
  '((t (:inherit font-lock-function-name-face)))
  "Face for SQL relation names."
  :group 'SQL)

(defface sql-ts-mode-relation-use-face
  '((t (:inherit font-lock-variable-use-face)))
  "Face for SQL relation references."
  :group 'SQL)

(defface sql-ts-mode-schema-name-face
  '((t (:inherit font-lock-type-face)))
  "Face for SQL schema names."
  :group 'SQL)

(defface sql-ts-mode-database-name-face
  '((t (:inherit font-lock-type-face)))
  "Face for SQL database names."
  :group 'SQL)


;;; Indentation

(defun sql-ts-mode--select-term-parent (node parent &rest args)
  "Determine NODE's PARENT depending on `sql-ts-mode-lineup-terms'.
ARGS are passed to function from `treesit-simple-indent-presets'."
  (when (null sql-ts-mode-lineup-terms)
    (setq node parent
          parent (treesit-node-parent parent)))
  (apply (alist-get (if sql-ts-mode-lineup-terms 'first-sibling 'parent-bol)
                    treesit-simple-indent-presets)
         node parent args))

(defun sql-ts-mode--select-term-offset (&rest _)
  "Return indent offset depending on `sql-ts-mode-lineup-terms'."
  (if sql-ts-mode-lineup-terms 0 sql-ts-mode-indent-offset))

(defun sql-ts-mode--align-sibilings (node &rest args)
  "Determine indentation for NODE to align with siblings of the same type.
The first sibling is is indented by `sql-ts-mode-indent-offset' with respect to
\\='parent-bol. Subsequent relations are aligned with the first.
ARGS are passed to function from `treesit-simple-indent-presets'."
  (let* ((anchor (if (equal (treesit-node-type node) ; "relation"
                            (treesit-node-type
                             (treesit-node-prev-sibling node t)))
                     'prev-sibling
                   'parent-bol))
         (offset (if (eq 'parent-bol anchor) sql-ts-mode-indent-offset 0)))
    (+ (apply (alist-get anchor treesit-simple-indent-presets) node args)
       offset)))

(defvar sql-ts-mode--indent-rules
  `((sql
     ((parent-is "program") column-0 0)
     ((node-is "]") parent-bol 0)
     ((node-is ")") parent-bol 0)

     ((node-is ,(rx bos "keyword_" (or "end" "then" "values"
                                       "union" "intersect")
                    eos))
      parent 0)

     ((match "statement" "transaction") parent-bol
      sql-ts-mode-transaction-indent-offset)
     ((parent-is "transaction") parent-bol 0)

     ;; XXX(08/02/24): indent in /*...*/ like c-ts-common?
     ((parent-is ,(rx bos (or "comment" "marginalia") eos)) no-indent)

     ((match ,(rx bos (or "join" "relation") eos) "from")
      parent-bol sql-ts-mode-indent-offset)
     ((parent-is "from") parent-bol 0)

     ((parent-is "limit") parent-bol 0)

     ((match "list" ,(rx (or "values" "insert"))) prev-sibling 0)
     ((node-is "assignment") prev-sibling 0)

     ((node-is ,(rx bos (or "relation" "table_option")))
      sql-ts-mode--align-sibilings 0)
     ;; XXX(08/10/24): first sibling includes keyword "ADD"
     ((node-is "add_column") sql-ts-mode--align-sibilings 0)

     ;; ((match "relation" "update") prev-sibling 0)
     ((parent-is ,(rx bos (or "insert" "update") eos)) parent-bol 0)

     ((match nil "binary_expression" "right")
      prev-sibling sql-ts-mode-indent-offset)
     ((match nil "binary_expression" "operator")
      standalone-parent sql-ts-mode-indent-offset)
     ((parent-is "unary_expression") parent sql-ts-mode-indent-offset)
     
     ;; Align AND with BETWEEN in ranges
     ((match "keyword_and" "window_frame") (nth-sibling 1) 0)

     ((parent-is
       ,(rx bos (or "where" "join" "case" "when_clause"
                    "cte" "invocation" "subquery" "list" "subscript"
                    "term" "field"  "relation"
                    "group_by" "order_by" "partition_by"
                    "not_similar_to" "similar_to"
                    "alter_" "drop_" ; all (create|drop|alter)_*
                    "create_function" "function_body" "function_arguments"
                    "create_index" "index_fields"
                    "create_table" "create_database" "create_type"
                    "create_view" "create_materialized_view"
                    "create_role" "create_sequence"
                    "create_extension" "create_trigger"
                    "column_definitions" "column_definition"
                    "enum_elements"
                    "window_function" "window_specification" "window_frame"
                    "binary_expression"
                    "storage_location" "row_format"
                    "set_statement" "reset_statement"
                    "table_partition" ;; "table_option"
                    )))
      parent-bol sql-ts-mode-indent-offset)

     ((node-is "constraint") parent-bol 0)
     ((parent-is ,(rx bos (or "add_constraint" "constraint" "constraints") eos))
      parent-bol sql-ts-mode-indent-offset)

     ((match "(" "statement") standalone-parent sql-ts-mode-indent-offset)
     ;; ((node-is "(") standalone-parent 0)
     ((node-is "statement") parent-bol sql-ts-mode-indent-offset)
     ((match
       ,(rx bos (or "select" "from" "where" "order_by") eos)
       ,(rx bos (or "statement" "create_")))
      parent-bol sql-ts-mode-statement-indent-offset)
     ((parent-is ,(rx bos (or "from" "statement") eos))
      parent-bol sql-ts-mode-indent-offset)

     ((match "(" "set_operation") standalone-parent 0)
     ((parent-is "set_operation") first-sibling 0)

     ((node-is "select_expression") parent-bol sql-ts-mode-indent-offset)
     ((parent-is ,(rx bos (or "select_expression")))
      sql-ts-mode--select-term-parent
      sql-ts-mode--select-term-offset)

     (no-node parent-bol 0)))
  "Tree-sitter indent rules for `sql-ts-mode'.")


;;; Font-locking

(defvar sql-ts-mode-feature-list
  '(( comment definition)
    ( keyword string)
    ( assignment builtin constant function number property type)
    ( bracket delimiter operator variable))
  "`treesit-font-lock-feature-list' for `sql-ts-mode'.")

;; TODO(7/29/24): nice to switch SQL product like `sql-mode', updating
;; relevant font-locking for builtins
(defconst sql-ts-mode--builtin-functions
  '()
  "SQL builtin functions for tree-sitter font-locking.")

(defvar sql-ts-mode--font-lock-settings
  (treesit-font-lock-rules
   :language 'sql
   :feature 'comment
   '([(comment) (marginalia)] @font-lock-comment-face)

   :language 'sql
   :feature 'constant
   '([(keyword_true) (keyword_false)] @font-lock-constant-face
     (function_language (identifier) @font-lock-constant-face)
     (alter_role option: (identifier) @font-lock-constant-face)
     (set_statement [(keyword_on) (keyword_off)] @font-lock-constant-face))

   :language 'sql
   :feature 'operator
   ;; TODO(7/29/24): (function_arguments [(keyword_in) (keyword_out)])
   `((dollar_quote) @font-lock-misc-punctuation-face
     (subscript ":" @font-lock-operator-face)
     (set_operation
      operation: [(_)] @font-lock-operator-face)

     [(not_like)
      (similar_to)
      (not_similar_to)
      (is_not)
      (keyword_is)
      (not_distinct_from)
      (distinct_from)

      (keyword_exists)
      (keyword_like)
      (keyword_in)
      (keyword_and)
      (keyword_or)
      (keyword_not)
      (keyword_by)
      (keyword_on)
      (keyword_do)
      (keyword_union)
      (keyword_except)
      (keyword_intersect)
      (keyword_match)
      (keyword_between)
      (bang)
      "+"
      "-"
      "*"
      "/"
      "%"
      "^"
      ":="
      "="
      "<"
      "<="
      "!="
      ">="
      ">"
      "<>"
      (op_other)
      (op_unary_other)]
     @font-lock-operator-face)

   :language 'sql
   :feature 'keyword
   `(;; Attributes
     [(keyword_asc)
      (keyword_desc)
      (keyword_terminated)
      (keyword_escaped)
      (keyword_nulls)
      (keyword_last)
      (keyword_delimited)
      (keyword_replication)
      (keyword_auto_increment)
      (keyword_default)
      (keyword_collate)
      (keyword_concurrently)
      (keyword_engine)
      (keyword_always)
      (keyword_generated)
      (keyword_preceding)
      (keyword_following)
      (keyword_first)
      (keyword_current_timestamp)
      (keyword_immutable)
      (keyword_atomic)
      (keyword_parallel)
      (keyword_leakproof)
      (keyword_safe)
      (keyword_cost)
      (keyword_strict)]
     @font-lock-preprocessor-face

     ;; Format
     [(keyword_delimiter)
      (keyword_quote)
      (keyword_escape)
      (keyword_freeze)
      (keyword_header)]
     @font-lock-keyword-face

     ;; Hive file formats
     [(keyword_parquet)
      (keyword_rcfile)
      (keyword_csv)
      (keyword_textfile)
      (keyword_avro)
      (keyword_sequencefile)
      (keyword_orc)
      (keyword_jsonfile)]

     ;; Modifiers
     [(keyword_materialized)
      (keyword_recursive)
      (keyword_temp)
      (keyword_temporary)
      (keyword_unlogged)
      (keyword_parquet)
      (keyword_csv)
      (keyword_rcfile)
      (keyword_textfile)
      (keyword_orc)
      (keyword_avro)
      (keyword_jsonfile)
      (keyword_sequencefile)
      (keyword_volatile)
      ;; Storage
      (keyword_plain)
      (keyword_external)
      (keyword_extended)
      (keyword_main)
      ]
     @font-lock-preprocessor-face

     [(keyword_compression)
      (keyword_data)
      (keyword_statistics)
      (keyword_storage)]
     @font-lock-keyword-face

     ;; Modifiers
     [(keyword_restrict)
      (keyword_restricted)
      (keyword_unbounded)
      (keyword_unique)
      (keyword_cascade)
      (keyword_delayed)
      (keyword_high_priority)
      (keyword_low_priority)
      (keyword_ignore)
      (keyword_nothing)
      (keyword_overwrite)
      (keyword_check)
      (keyword_option)
      (keyword_local)
      (keyword_cascaded)
      (keyword_wait)
      (keyword_nowait)
      (keyword_metadata)
      (keyword_incremental)
      (keyword_bin_pack)
      (keyword_noscan)
      (keyword_stats)
      (keyword_maxvalue)
      (keyword_minvalue)]
     @font-lock-preprocessor-face

     ;; Keywords
     [(keyword_case)
      (keyword_when)
      (keyword_then)
      (keyword_else)
      (keyword_select)
      (keyword_from)
      (keyword_where)
      (keyword_index)
      (keyword_join)
      (keyword_primary)
      (keyword_delete)
      (keyword_create)
      (keyword_insert)
      (keyword_copy)
      (keyword_merge)
      (keyword_distinct)
      (keyword_replace)
      (keyword_update)
      (keyword_into)
      ;; (keyword_overwrite)
      (keyword_matched)
      (keyword_values)
      (keyword_value)
      (keyword_attribute)
      (keyword_set)
      (keyword_left)
      (keyword_right)
      (keyword_outer)
      (keyword_inner)
      (keyword_full)
      (keyword_order)
      (keyword_partition)
      (keyword_group)
      (keyword_with)
      (keyword_without)
      (keyword_as)
      (keyword_having)
      (keyword_limit)
      (keyword_offset)
      (keyword_table)
      (keyword_tables)
      (keyword_key)
      (keyword_references)
      (keyword_foreign)
      (keyword_constraint)
      (keyword_force)
      (keyword_use)
      (keyword_for)
      (keyword_if)
      (keyword_exists)
      (keyword_max)
      (keyword_min)
      (keyword_avg)
      (keyword_column)
      (keyword_columns)
      (keyword_cross)
      (keyword_lateral)
      (keyword_natural)
      (keyword_alter)
      (keyword_drop)
      (keyword_add)
      (keyword_view)
      (keyword_end)
      (keyword_is)
      (keyword_using)
      (keyword_window)
      (keyword_no)
      (keyword_type)
      (keyword_rename)
      (keyword_to)
      (keyword_schema)
      (keyword_owner)
      (keyword_authorization)
      (keyword_all)
      (keyword_any)
      (keyword_some)
      (keyword_returning)
      (keyword_begin)
      (keyword_commit)
      (keyword_rollback)
      (keyword_transaction)
      (keyword_only)
      (keyword_like)
      (keyword_similar)
      (keyword_over)
      (keyword_change)
      (keyword_modify)
      (keyword_after)
      (keyword_before)
      (keyword_range)
      (keyword_rows)
      (keyword_groups)
      (keyword_exclude)
      (keyword_current)
      (keyword_ties)
      (keyword_others)
      (keyword_preserve)
      (keyword_zerofill)
      (keyword_format)
      (keyword_fields)
      (keyword_row)
      (keyword_sort)
      (keyword_compute)
      (keyword_comment)
      (keyword_location)
      (keyword_cached)
      (keyword_uncached)
      (keyword_lines)
      (keyword_stored)
      (keyword_virtual)
      (keyword_partitioned)
      (keyword_analyze)
      (keyword_explain)
      (keyword_verbose)
      (keyword_truncate)
      (keyword_rewrite)
      (keyword_optimize)
      (keyword_vacuum)
      (keyword_cache)
      (keyword_language)
      (keyword_sql)
      (keyword_called)
      (keyword_conflict)
      (keyword_declare)
      (keyword_filter)
      (keyword_function)
      (keyword_input)
      (keyword_name)
      (keyword_oid)
      (keyword_oids)
      (keyword_options)
      (keyword_plpgsql)
      (keyword_precision)
      (keyword_regclass)
      (keyword_regnamespace)
      (keyword_regproc)
      (keyword_regtype)
      (keyword_return)
      (keyword_returns)
      (keyword_separator)
      (keyword_setof)
      (keyword_stable)
      (keyword_support)
      (keyword_tblproperties)
      (keyword_trigger)
      (keyword_unsafe)
      (keyword_admin)
      (keyword_connection)
      (keyword_cycle)
      (keyword_database)
      (keyword_encrypted)
      (keyword_increment)
      (keyword_logged)
      (keyword_none)
      (keyword_owned)
      (keyword_password)
      (keyword_reset)
      (keyword_role)
      (keyword_sequence)
      (keyword_start)
      (keyword_restart)
      (keyword_tablespace)
      (keyword_until)
      (keyword_user)
      (keyword_valid)
      (keyword_action)
      (keyword_definer)
      (keyword_invoker)
      (keyword_security)
      (keyword_extension)
      (keyword_version)
      (keyword_out)
      (keyword_inout)
      (keyword_variadic)
      (keyword_session)
      (keyword_isolation)
      (keyword_level)
      (keyword_serializable)
      (keyword_repeatable)
      (keyword_read)
      (keyword_write)
      (keyword_committed)
      (keyword_uncommitted)
      (keyword_deferrable)
      (keyword_names)
      (keyword_zone)
      (keyword_immediate)
      (keyword_deferred)
      (keyword_constraints)
      (keyword_snapshot)
      (keyword_characteristics)
      (keyword_off)
      (keyword_follows)
      (keyword_precedes)
      (keyword_each)
      (keyword_instead)
      (keyword_of)
      (keyword_initially)
      (keyword_old)
      (keyword_new)
      (keyword_referencing)
      (keyword_statement)
      (keyword_execute)
      (keyword_procedure)]
     @font-lock-keyword-face)

   ;; :language 'sql
   ;; :feature 'builtin
   ;; '()

   :language 'sql
   :feature 'function
   '((invocation
      (object_reference
       name: (identifier) @font-lock-function-call-face))

     [(keyword_gist)
      (keyword_btree)
      (keyword_hash)
      (keyword_spgist)
      (keyword_gin)
      (keyword_brin)
      (keyword_array)]
     @font-lock-builtin-face

     (term
      value: (cast
              name: (keyword_cast) @font-lock-function-call-face
              parameter: (literal) :?))
     (keyword_cast) @font-lock-function-call-face

     (create_trigger
      (keyword_function)
      (object_reference
       name: (identifier) @font-lock-function-call-face))
     ;; (function_argument (identifier) @font-lock-variable-use-face)
     )

   :language 'sql
   :feature 'definition
   (let ((create-kws '((keyword_if) (keyword_not) (keyword_exists))))
     (cl-flet*
         ((create-rule (name &optional object-ref kws id-node face)
            (let ((node (intern (concat "create_" name)))
                  (kw (intern (concat "keyword_" name)))
                  (face (or face '@sql-ts-mode-relation-name-face)))
              `(,node [(,kw) ,@kws ,@create-kws] :anchor
                      ,@(or id-node
                            (if object-ref `((object_reference
                                              name: (identifier) ,face))
                              `((identifier) ,face)))))))
       `((column_definition name: [(literal) (identifier)] @font-lock-property-name-face)

         (constraint name: (identifier) @font-lock-property-name-face)

         (term alias: (identifier) @font-lock-property-name-face)

         (insert alias: (identifier) @font-lock-variable-name-face)

         (statement alias: (identifier) @font-lock-variable-name-face)

         (relation alias: (identifier) @font-lock-variable-name-face)

         (lateral_cross_join alias: (identifier) @font-lock-variable-name-face)

         (lateral_join alias: (identifier) @font-lock-variable-name-face)

         (cte (identifier) @sql-ts-mode-relation-name-face :anchor
              argument: (identifier) @font-lock-variable-name-face :?)

         (table_option name: (identifier) @font-lock-property-name-face)
         (table_option
          (keyword_set) :anchor (identifier) @font-lock-property-name-face)

         (create_role option: (identifier) @font-lock-preprocessor-face)

         (create_function
          (keyword_function) :anchor
          (object_reference name: (identifier) @font-lock-function-name-face)
          custom_type: (_) :? @font-lock-type-face)

         (function_argument (identifier) @font-lock-variable-name-face)

         (window_clause (identifier) @font-lock-variable-name-face)

         (create_index
          (keyword_index) :anchor
          column: (identifier) @font-lock-variable-name-face)
         (index_hint
          index_name: (identifier) @font-lock-property-name-face)

         ,(create-rule "schema" nil nil nil '@sql-ts-mode-schema-name-face)
         ,(create-rule "role")
         ,(create-rule "database")
         ,(create-rule "extension")
         ,(create-rule "type" 'object nil nil '@font-lock-type-face)
         ,(create-rule "trigger" 'object)
         ,(create-rule "table" 'object)
         ,(create-rule "sequence" 'object '((keyword_temp)))

         ,(create-rule
           "view" nil '((keyword_temp))
           '(((object_reference
               name: (identifier) @sql-ts-mode-relation-name-face)
              (identifier) @font-lock-variable-name-face :?
              ("," (identifier) @font-lock-variable-name-face) :*)))

         (create_materialized_view
          [(keyword_materialized) (keyword_view) ,@create-kws] :anchor
          (object_reference
           name: (identifier) @sql-ts-mode-relation-name-face)))))

   :language 'sql
   :feature 'assignment
   `((alter_table
      (object_reference
       name: (identifier) @sql-ts-mode-relation-use-face))
     (alter_column name: (identifier) @font-lock-property-use-face)
     (rename_column new_name: (identifier) @font-lock-property-name-face)

     (alter_database
      (rename_object
       (object_reference name: (identifier) @sql-ts-mode-database-name-face)))

     (alter_view
      (object_reference name: (identifier) @font-lock-variable-use-face))

     (alter_schema
      (identifier) (keyword_rename) (keyword_to) :anchor
      (identifier) @sql-ts-mode-schema-name-face)

     (alter_index
      (keyword_index) :anchor [(keyword_if) (keyword_exists)] :* :anchor
      (identifier) @font-lock-property-use-face)

     (alter_index
      (rename_object
       (object_reference
        name: (identifier) @font-lock-property-name-face)))

     (alter_sequence
      (rename_object
       (object_reference
        name: (identifier) @font-lock-property-name-face)))

     (alter_type
      (rename_object
       (object_reference
        name: (identifier) @font-lock-type-face)))

     (alter_role
      (rename_object
       (object_reference
        name: (identifier) @font-lock-property-name-face)))

     (add_constraint (identifier) @font-lock-property-name-face)

     (set_schema schema: (identifier) @sql-ts-mode-schema-name-face)

     (set_configuration option: (identifier) @font-lock-variable-name-face)
     (alter_database
      configuration_parameter: (identifier) @font-lock-variable-name-face)

     (set_statement
      (object_reference name: (identifier) @font-lock-variable-name-face))
     (reset_statement
      (object_reference name: (identifier) @font-lock-variable-name-face))

     (assignment
      left: (field (identifier) @font-lock-variable-name-face)))

   :language 'sql
   :feature 'property
   `((column (identifier) @font-lock-property-use-face)
     (field name: (identifier) @font-lock-property-use-face)
     (field column: (identifier) @font-lock-property-use-face)
     (table_partition (identifier) @font-lock-property-use-face)
     (table_sort (identifier) @font-lock-property-use-face))

   :language 'sql
   :feature 'type
   '((object_reference
      schema: (identifier) @sql-ts-mode-schema-name-face)
     (column_definition custom_type: (_) @font-lock-type-face)
     (cast custom_type: (_) @font-lock-type-face)
     (create_type name: (identifier) @font-lock-property-name-face)

     [(keyword_int)
      (keyword_null)
      (keyword_unsigned)
      (keyword_boolean)
      (keyword_binary)
      (keyword_varbinary)
      (keyword_image)
      (keyword_bit)
      (keyword_inet)
      (keyword_character)
      (keyword_smallserial)
      (keyword_serial)
      (keyword_bigserial)
      (keyword_smallint)
      (keyword_mediumint)
      (keyword_bigint)
      (keyword_tinyint)
      (keyword_decimal)
      (keyword_float)
      (keyword_double)
      (keyword_numeric)
      (keyword_real)
      (double)
      (keyword_money)
      (keyword_smallmoney)
      (keyword_char)
      (keyword_nchar)
      (keyword_varchar)
      (keyword_nvarchar)
      (keyword_varying)
      (keyword_text)
      (keyword_string)
      (keyword_uuid)
      (keyword_json)
      (keyword_jsonb)
      (keyword_xml)
      (keyword_bytea)
      (keyword_enum)
      (keyword_date)
      (keyword_datetime)
      (keyword_time)
      (keyword_datetime2)
      (keyword_datetimeoffset)
      (keyword_smalldatetime)
      (keyword_timestamp)
      (keyword_timestamptz)
      (keyword_geometry)
      (keyword_geography)
      (keyword_box2d)
      (keyword_box3d)
      (keyword_interval)
      (keyword_stdin)]
     @font-lock-type-face)

   :language 'sql
   :feature 'number
   :override 'keep
   '(((literal) @font-lock-number-face
      (:match "^[+-]?[[:digit:]]*\\(?:\\.[[:digit:]]*\\)?$"
              @font-lock-number-face))
     (interval) @font-lock-number-face
     ;; create_function
     [(function_cost) (function_rows)] @font-lock-number-face)

   :language 'sql
   :feature 'string
   '((literal) @font-lock-string-face
     (interval (keyword_interval) _ @font-lock-string-face)
     (statement "filename" @font-lock-string-face))

   :language 'sql
   :feature 'variable
   '((parameter) @font-lock-variable-use-face
     (object_reference
      name: (identifier) @sql-ts-mode-relation-use-face)
     (window_function (identifier) @font-lock-variable-use-face))

   :language 'sql
   :feature 'delimiter
   '([";" "," "."] @font-lock-delimiter-face)

   :language 'sql
   :feature 'bracket
   `(["(" ")" "[" "]"] @font-lock-bracket-face))
  "Tree-sitter font-lock settings for SQL.")


;;;###autoload
(define-derived-mode sql-ts-mode prog-mode "SQL"
  "Major mode for editing SQL, powered by tree-sitter."
  :syntax-table sql-mode-syntax-table
  :group 'SQL

  (when (treesit-ready-p 'sql)
    (treesit-parser-create 'sql)

    ;; Comments
    (setq-local comment-start "--")
    (setq-local comment-end "")
    (setq-local comment-start-skip (rx (or (seq "-" (+ "-"))
                                           (seq "/" (+ "*")))
                                       (* (syntax whitespace))))
    (setq-local comment-end-skip
                (rx (* (syntax whitespace))
                    (group (or (syntax comment-end)
                               (seq (+ "*") "/")))))
    (setq-local paragraph-separate "[\f]*$")
    (setq-local paragraph-start "[\n\f]")
    (setq-local paragraph-ignore-fill-prefix t)
    (setq-local escaped-string-quote "'")

    ;; Electric
    (setq-local electric-indent-chars
                (append "();," electric-indent-chars))
    (setq-local electric-layout-rules
	        '((?\; . after) (?\( . after) (?\) . before)))

    ;; Abbrevs
    (setq-local abbrev-all-caps 1)

    ;; Indentation
    (setq-local treesit-simple-indent-rules sql-ts-mode--indent-rules)

    ;; Font-Locking
    (setq-local treesit-font-lock-settings sql-ts-mode--font-lock-settings)
    (setq-local treesit-font-lock-feature-list sql-ts-mode-feature-list)

    ;; TODO: Navigation
    ;; (setq-local treesit-defun-type-regexp "")
    ;; (setq-local treesit-defun-name-function #'sql-ts-mode--defun-name)

    ;; TODO: Imenu
    ;; (setq-local treesit-simple-imenu-settings '(())

    (treesit-major-mode-setup)))

(derived-mode-add-parents 'sql-ts-mode '(sql-mode))

(if (treesit-ready-p 'sql)
    (add-to-list 'auto-mode-alist '("\\.sql\\'" . sql-ts-mode)))

(provide 'sql-ts-mode)
;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:
;;; sql-ts-mode.el ends here
