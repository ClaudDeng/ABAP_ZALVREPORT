class zcl_ba_alv_display definition
  public
  final
  create public .

  public section.

    data s_variant type disvariant .
    data o_alv type ref to cl_gui_alv_grid .
    data o_alv_display_attr type ref to zcl_ba_alv_display_attr.
    data o_alv_display_event type ref to zif_ba_alv_event.
    data v_handle type slis_handl .
    methods constructor
      importing
        iv_handle            type slis_handl
        iv_parent            type ref to cl_gui_container
        io_alv_display_attr  type  ref to zcl_ba_alv_display_attr
        io_alv_display_event type  ref to zif_ba_alv_event.
    methods show_data
      changing
        ct_outtab type any table.   " Output Table.
    methods refresh .
    methods check_changed_data .

    methods register_event .
    methods set_variant .

  protected section.
  private section.

endclass.



class zcl_ba_alv_display implementation.


  method show_data.

    register_event( ).
    set_variant(  ).
    "显示ALV
    call method o_alv->set_table_for_first_display
      exporting
*       i_buffer_active               =     " Buffering Active
*       i_bypassing_buffer            =     " Switch Off Buffer
*       i_consistency_check           =     " Starting Consistency Check for Interface Error Recognition
*       i_structure_name              =     " Internal Output Table Structure Name
        is_variant                    = s_variant    " Layout
        i_save                        = 'A'    " Save Layout
        i_default                     = 'X'    " Default Display Variant
        is_layout                     = o_alv_display_attr->s_layout   " Layout
*       is_print                      =     " Print Control
*       it_special_groups             =     " Field Groups
        it_toolbar_excluding          = o_alv_display_attr->t_exclude_func   " Excluded Toolbar Standard Functions
*       it_hyperlink                  =     " Hyperlinks
*       it_alv_graphics               =     " Table of Structure DTC_S_TC
*       it_except_qinfo               =     " Table for Exception Quickinfo
*       ir_salv_adapter               =     " Interface ALV Adapter
      changing
        it_outtab                     = ct_outtab   " Output Table
        it_fieldcatalog               = o_alv_display_attr->t_fldcat  " Field Catalog
*       it_sort                       =     " Sort Criteria
*       it_filter                     =     " Filter Criteria
      exceptions
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        others                        = 4.
    if sy-subrc <> 0.
*     message id sy-msgid type sy-msgty number sy-msgno
*                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

    "注册事件
    o_alv->register_edit_event( exporting i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

  endmethod.
  method check_changed_data.
    o_alv->check_changed_data( ).
  endmethod.

  method constructor.
    "创建FIELDS的ALV
    create object o_alv
      exporting
        i_parent = iv_parent.
    v_handle = iv_handle.
    o_alv_display_attr =  io_alv_display_attr.
    o_alv_display_event =  io_alv_display_event.

    me->register_event( ).
  endmethod.

  method refresh.
    data ls_stable type lvc_s_stbl.
    ls_stable-row = 'X'.
    ls_stable-col = 'X'.
    call method o_alv->refresh_table_display
      exporting
        is_stable = ls_stable
      exceptions
        finished  = 1
        others    = 2.
    if sy-subrc <> 0.
    endif.
  endmethod.

  method register_event.
    o_alv_display_event->register_event( io_alv = o_alv ).

  endmethod.


  method set_variant.
    s_variant-report = sy-repid.
    s_variant-handle = v_handle.
  endmethod.

endclass.
