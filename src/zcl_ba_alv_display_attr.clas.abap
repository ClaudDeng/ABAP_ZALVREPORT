class zcl_ba_alv_display_attr definition
  public
  final
  create public .

  public section.
    types: begin of ty_fcode,
             fcode type sy-ucomm,
           end of ty_fcode.
    types: ty_t_fcode type table of ty_fcode.
    types: begin of ty_fldcat_line,
             fieldname        type lvc_fname,
             fldcat_col_name  type lvc_fname,
             fldcat_col_value type char100,
           end of ty_fldcat_line.
    types: ty_t_fldcat_line type table of ty_fldcat_line.
    types: ty_t_fldname type table of  lvc_rfname.
    "状态栏属性
    data t_status_exclude_fcode type ty_t_fcode.
    data v_status_title type char50 .
    data v_grid_title type lvc_s_layo-grid_title.
    "ALV属性
    data t_fldcat type lvc_t_fcat .
    data t_exclude_func type ui_functions . "toolbar
    data t_exclude_fld type ty_t_fldname.
    data s_layout type lvc_s_layo .
    data v_struct_name type dd02l-tabname.

    methods constructor
      importing
        it_exclude_fld  type ty_t_fldname optional
        iv_status_title type lvc_title optional
        iv_grid_title   type  lvc_title optional
        iv_struct_name  type  dd02l-tabname optional.


    methods change_t_fldcat
      importing
        iv_overwrite   type c default ''
        it_fldcat_col  type  lvc_t_fcat optional
        it_fldcat_line type ty_t_fldcat_line optional.

  protected section.
  private section.
    methods set_s_layout .
    methods set_t_fldcat  .
    methods set_t_status_exclude_fcode.
    methods set_t_exclude_func.
endclass.



class zcl_ba_alv_display_attr implementation.


  method constructor.
    t_exclude_fld = it_exclude_fld.
    v_status_title = iv_status_title.
    v_grid_title = iv_grid_title .
    v_struct_name = iv_struct_name.
    me->set_t_fldcat( ).
    me->set_s_layout( ).
    me->set_t_exclude_func( ).
    me->set_t_status_exclude_fcode( ).
  endmethod.


  method change_t_fldcat.
    field-symbols <fs_to_fldcat> type lvc_s_fcat.
    if iv_overwrite eq 'X'
        or t_fldcat is initial .
      t_fldcat = it_fldcat_col.
      return.
    endif.
    if it_fldcat_col is not initial.
      loop at it_fldcat_col assigning field-symbol(<fs_src_fldcat>).
        read table t_fldcat assigning <fs_to_fldcat> with key fieldname = <fs_src_fldcat>-fieldname.
        if sy-subrc eq 0.
          move-corresponding <fs_src_fldcat> to <fs_to_fldcat>.
        else.
          append <fs_src_fldcat> to t_fldcat.
        endif.
      endloop.
    endif.
    if it_fldcat_line is not initial.
      loop at it_fldcat_line assigning field-symbol(<fs_line>).
        read table t_fldcat assigning <fs_to_fldcat> with key fieldname = <fs_line>-fieldname.
        if sy-subrc eq 0.
          assign component to_upper( <fs_line>-fldcat_col_name  ) of structure <fs_to_fldcat> to field-symbol(<fs_fld_value>).
          if <fs_fld_value> is assigned .
            <fs_fld_value> = <fs_line>-fldcat_col_value.
          endif.
        endif.
      endloop.
    endif.
  endmethod.


  method set_s_layout.
    s_layout-grid_title = v_grid_title.
    s_layout-zebra = 'X'.
    s_layout-sel_mode = 'A'.
    s_layout-smalltitle = 'X'.
    s_layout-cwidth_opt  = 'X'.
    s_layout-stylefname   = 'CELLSTYPE'.
  endmethod.


  method set_t_exclude_func.

*    append cl_gui_alv_grid=>mc_fc_maximum to t_exclude_func.
*    append cl_gui_alv_grid=>mc_fc_minimum to t_exclude_func.
*    append cl_gui_alv_grid=>mc_fc_subtot to t_exclude_func.
*    append cl_gui_alv_grid=>mc_fc_sum to t_exclude_func.
*    append cl_gui_alv_grid=>mc_fc_average to t_exclude_func.
*    append cl_gui_alv_grid=>mc_mb_sum to t_exclude_func.
*    append cl_gui_alv_grid=>mc_mb_subtot to t_exclude_func.
*    append cl_gui_alv_grid=>mc_fc_sort_asc to t_exclude_func.
*    append cl_gui_alv_grid=>mc_fc_sort_dsc to t_exclude_func.
*    append cl_gui_alv_grid=>mc_fc_find to t_exclude_func.
*    append cl_gui_alv_grid=>mc_fc_filter to t_exclude_func.

    append cl_gui_alv_grid=>mc_fc_print to t_exclude_func.
    append cl_gui_alv_grid=>mc_fc_print_prev to t_exclude_func.
*    append cl_gui_alv_grid=>mc_mb_export to t_exclude_func.
    append cl_gui_alv_grid=>mc_fc_graph to t_exclude_func.
*    append cl_gui_alv_grid=>mc_mb_export to t_exclude_func.
*    append cl_gui_alv_grid=>mc_mb_view to t_exclude_func.
*    append cl_gui_alv_grid=>mc_fc_detail to t_exclude_func.
    append cl_gui_alv_grid=>mc_fc_help to t_exclude_func.
    append cl_gui_alv_grid=>mc_fc_info to t_exclude_func.
*    append cl_gui_alv_grid=>mc_mb_variant to t_exclude_func.
*    append cl_gui_alv_grid=>mc_fc_refresh to t_exclude_func.
    append cl_gui_alv_grid=>mc_fc_check to t_exclude_func.
    append cl_gui_alv_grid=>mc_fc_loc_copy to t_exclude_func.
    append cl_gui_alv_grid=>mc_fc_loc_insert_row to t_exclude_func.
    append cl_gui_alv_grid=>mc_fc_loc_delete_row to t_exclude_func.
    append cl_gui_alv_grid=>mc_fc_loc_copy_row to t_exclude_func.
    append cl_gui_alv_grid=>mc_fc_loc_append_row to t_exclude_func.
    append cl_gui_alv_grid=>mc_fc_loc_undo to t_exclude_func.
    append cl_gui_alv_grid=>mc_fc_loc_cut to t_exclude_func.
    append cl_gui_alv_grid=>mc_mb_paste to t_exclude_func.

  endmethod.


  method set_t_fldcat.
    "子类重写

    if v_struct_name is initial..
      return.
    endif.

    call function 'LVC_FIELDCATALOG_MERGE'
      exporting
*       I_BUFFER_ACTIVE        =
        i_structure_name       = v_struct_name
        i_client_never_display = 'X'
        i_bypassing_buffer     = 'X'
*       I_INTERNAL_TABNAME     =
      changing
        ct_fieldcat            = t_fldcat
      exceptions
        inconsistent_interface = 1
        program_error          = 2
        others                 = 3.
    if sy-subrc <> 0.
* Implement suitable error handling here
    endif.
    data: lr_fld type range of lvc_rfname.
    if t_exclude_fld is not initial.
      lr_fld = value #( for ls_fld in t_exclude_fld
                         ( sign = 'I' option = 'EQ' low = ls_fld )
                         ).
      delete t_fldcat where fieldname in lr_fld.
    endif.

    delete t_fldcat where fieldname = 'MANDT'.
  endmethod.


  method set_t_status_exclude_fcode.

  endmethod.
endclass.
