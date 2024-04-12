;;; sql-ts-mode.el --- Tree-sitter support for SQL -*- lexical-binding: t; -*-

;; Author: Noah Peart <noah.v.peart@gmail.com>
;; URL: https://github.com/nverno/sql-ts-mode
;; Version: 0.0.1
;; Package-Requires: ((emacs "29.1"))
;; Created: 12 April 2024
;; Keywords:

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
;;; Code:

(require 'treesit)


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


;;; Indentation

(defun sql-ts-mode--select-term-parent (node parent &rest args)
  (when (null sql-ts-mode-lineup-terms)
    (setq node parent
          parent (treesit-node-parent parent)))
  (apply (alist-get (if sql-ts-mode-lineup-terms 'first-sibling 'parent-bol)
                    treesit-simple-indent-presets)
         node parent args))

(defun sql-ts-mode--select-term-offset (&rest _)
  (if sql-ts-mode-lineup-terms 0 sql-ts-mode-indent-offset))

(defvar sql-ts-mode--indent-rules
  `((sql
     ((parent-is "program") column-0 0)
     ((node-is ")") parent-bol 0)
     ((node-is "]") parent-bol 0)
     ((node-is
       ,(rx bos "keyword_"
            (or "union" "end"
                ;; WHEN clause
                "then" "values" "set")
            eos))
      parent-bol 0)

     ((match ,(rx bos (or "join" "relation") eos) "from")
      parent-bol sql-ts-mode-indent-offset)
     ((parent-is "from") parent-bol 0)

     ((parent-is
       ,(rx bos (or "where" "join" "group_by" "order_by" "case" "term"
                    "cte" "invocation" "relation" "subquery"

                    "alter_view" "alter_table"

                    "create_table" "create_database" "create_type"
                    "create_view" "create_materialized_view"
                    "create_role" "create_sequence"
                    "create_extension" "create_trigger"
                    
                    "column_definitions" "column_definition"
                    "enum_elements"
                    "window_function" "window_specification"
                    "binary_expression"
                    "storage_location" "row_format")
            eos))
      parent-bol sql-ts-mode-indent-offset)

     ((node-is "constraint") parent-bol 0)
     ((parent-is ,(rx bos (or "add_constraint" "constraints") eos))
      parent-bol sql-ts-mode-indent-offset)

     ((node-is "(") parent-bol 0)
     ((node-is "statement") parent-bol sql-ts-mode-indent-offset)
     ((match
       ,(rx bos (or "select" "from" "where" "order_by") eos)
       ,(rx bos (or "set_operation" "statement" "create_query")))
      parent-bol sql-ts-mode-statement-indent-offset)
     ((parent-is ,(rx bos (or "set_operation" "statement") eos))
      parent-bol sql-ts-mode-indent-offset)

     ;; FIXME: add_column grammar is funny
     ((node-is "add_column") parent-bol sql-ts-mode-indent-offset)
     ((parent-is "add_column") sql-ts-mode--select-term-parent
      sql-ts-mode--select-term-offset)

     ((node-is "select_expression") parent-bol sql-ts-mode-indent-offset)
     ((parent-is "select_expression") sql-ts-mode--select-term-parent
      sql-ts-mode--select-term-offset)

     ;; ((parent-is "string") no-indent)
     (no-node parent-bol 0)))
  "Tree-sitter indent rules for `sql-ts-mode'.")


;;; Font-locking

(defconst sql-ts-mode--keywords
  '()
  "SQL keywords for font-locking.")

(defconst sql-ts-mode--operators
  '()
  "SQL operators for tree-sitter font-locking.")

(defvar sql-ts-mode-feature-list
  '(( comment definition)
    ( keyword string)
    ( builtin type constant number assignment function) ; property
    ( operator variable bracket delimiter))
  "`treesit-font-lock-feature-list' for `sql-ts-mode'.")

(defvar sql-ts-mode--font-lock-settings
  (treesit-font-lock-rules
   :language 'sql
   :feature 'comment
   '([(comment) (marginalia)] @font-lock-comment-face)

   ;; :language 'sql
   ;; :feature 'string
   ;; '((literal) @font-lock-string-face)

   ;; :language 'sql
   ;; :feature 'escape-sequence
   ;; :override t
   ;; '((escape_sequence) @font-lock-escape-face)

   :language 'sql
   :feature 'keyword
   `(;; Attributes
     [(keyword_asc)
      (keyword_desc)
      (keyword_terminated)
      (keyword_escaped)
      (keyword_unsigned)
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

     ;; Modifiers
     [(keyword_materialized)
      (keyword_recursive)
      (keyword_temp)
      (keyword_temporary)
      (keyword_unlogged)
      (keyword_external)
      (keyword_parquet)
      (keyword_csv)
      (keyword_rcfile)
      (keyword_textfile)
      (keyword_orc)
      (keyword_avro)
      (keyword_jsonfile)
      (keyword_sequencefile)
      (keyword_volatile)]
     @font-lock-keyword-face

     [(keyword_restrict)
      (keyword_unbounded)
      (keyword_unique)
      (keyword_cascade)
      (keyword_delayed)
      (keyword_high_priority)
      (keyword_low_priority)
      (keyword_ignore)
      (keyword_nothing)
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
      (keyword_statistics)
      (keyword_maxvalue)
      (keyword_minvalue)]
     @font-lock-keyword-face
     
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
      (keyword_merge)
      (keyword_distinct)
      (keyword_replace)
      (keyword_update)
      (keyword_into)
      (keyword_overwrite)
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
      (keyword_between)
      (keyword_window)
      (keyword_no)
      (keyword_data)
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
      (keyword_restricted)
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
     @font-lock-function-call-face

     (term
      value: (cast
              name: (keyword_cast) @font-lock-function-call-face
              parameter: (literal) :?)))

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
       `((column_definition
          name: (identifier) @font-lock-property-name-face)
         
         (constraint
          name: (identifier) @font-lock-property-name-face)
         
         (term
          alias: (identifier) @font-lock-property-name-face)

         (relation
          alias: (identifier) @sql-ts-mode-relation-name-face)

         (cte (identifier) @sql-ts-mode-relation-name-face :anchor
              argument: (identifier) @font-lock-variable-name-face :?)
         
         ,(create-rule "schema")
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

   ;; :language 'sql
   ;; :feature 'builtin
   ;; '()

   :language 'sql
   :feature 'type
   '(;; (object_reference
     ;;  name: (identifier) @font-lock-type-face)
     
     [(keyword_int)
      (keyword_null)
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
      (keyword_interval)]
     @font-lock-type-face)

   :language 'sql
   :feature 'number
   '(((literal) @font-lock-number-face
      (:match "^[+-]?[[:digit:]]*\\(?:\\.[[:digit:]]*\\)?$" @font-lock-number-face)))

   :language 'sql
   :feature 'constant
   '([(keyword_true) (keyword_false)] @font-lock-constant-face
     (literal) @font-lock-string-face)

   ;; :language 'sql
   ;; :feature 'assignment
   ;; '()

   :language 'sql
   :feature 'variable
   '((parameter) @font-lock-variable-use-face

     (relation
      (object_reference
       name: (identifier) @font-lock-property-use-face))

     (field
      name: (identifier) @font-lock-property-use-face))

   :language 'sql
   :feature 'operator
   `([(keyword_in)
      (keyword_and)
      (keyword_or)
      (keyword_not)
      (keyword_by)
      (keyword_on)
      (keyword_do)
      (keyword_union)
      (keyword_except)
      (keyword_intersect)
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
   :feature 'delimiter
   '([";" "," "."] @font-lock-delimiter-face)

   :language 'sql
   :feature 'bracket
   `(["(" ")" "[" "]"] @font-lock-bracket-face))
  "Tree-sitter font-lock settings for SQL.")


;;;###autoload
(define-derived-mode sql-ts-mode prog-mode "SQL"
  "Major mode for editing SQL, powered by tree-sitter."
  :group 'SQL

  (when (treesit-ready-p 'sql)
    (treesit-parser-create 'sql)

    ;; Comments
    (setq-local comment-start "--")
    (setq-local comment-end "")
    (setq-local comment-start-skip (rx "--" (* (syntax whitespace))))

    (setq-local paragraph-separate "[\f]*$")
    (setq-local paragraph-start "[\n\f]")
    (setq-local paragraph-ignore-fill-prefix t)
    (setq-local escaped-string-quote "'")

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

(provide 'sql-ts-mode)
;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:
;;; sql-ts-mode.el ends here
