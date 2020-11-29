interface zif_ba_alv_event
  public .

  data t_f4_field type lvc_t_f4.

  methods handle_user_command
      for event user_command of cl_gui_alv_grid
    importing
      !e_ucomm
      !sender .
  methods handle_hotspot_click
      for event hotspot_click of cl_gui_alv_grid
    importing
      e_row_id
      e_column_id
      es_row_no
      sender .
  methods handle_f4
      for event onf4 of cl_gui_alv_grid
    importing
      e_fieldname
      e_fieldvalue
      es_row_no
      er_event_data
      et_bad_cells
      e_display
      sender .
  methods handle_toolbar
      for event toolbar of cl_gui_alv_grid
    importing
      e_object
      e_interactive
      sender .

  methods set_t_f4_field.
  "! <p class="shorttext synchronized" lang="en"></p>
  "! 实现的类必须注册事件，在zcl_ba_alv_display中未实现动态注册
  methods register_event
    importing
        io_alv type ref to cl_gui_alv_grid.
endinterface.
