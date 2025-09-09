# SAP ABAP Internship Projects

This repository includes a variety of simple to intermediate ABAP reports and utility programs developed during my 2025 internship.  
The projects aim to strengthen basic ABAP skills through hands-on practice with commonly used programming structures, such as loops, conditions, parameters, and output formatting.

These exercises are suitable for beginners and early-stage learners looking to build a solid foundation in SAP ABAP development.

---

## Tasks Overview

### `task00_number_checks`  
Analyzes numbers from 0 to 100 by classifying them as even or odd and counting each type.  
Also lists numbers divisible by 2, 3, and 5, and checks where a user-input value falls within specific numeric ranges.

### `task01_calculator_fm`  
Implements a basic calculator using **Function Modules** in ABAP.  
Supports arithmetic operations (add, subtract, multiply, divide) with modular structure and user input handling.

### `task01_calculator_perform`  
A simple calculator program built using **FORM routines (`PERFORM`)** to organize arithmetic operations in a structured and reusable way.

### `task01_calculator_screen`  
Presents a basic **interactive screen (dynpro)** for the calculator using `SE51`.  
Includes input/output fields for numbers and operations, showcasing screen-based user interaction in ABAP.

### `task02_alv_order_list`  
Generates a structured **ALV (ABAP List Viewer)** report displaying a list of customer orders.  
Demonstrates usage of ALV functions to sort, filter, and format tabular data dynamically.

### `task03_material_alv_filter`  
Defines a material structure containing material number, description, and price fields.  
Initializes example data directly within the program and uses a **SELECT-OPTIONS** range to let the user specify a material number interval.  
Filters the internal table based on the user's input and displays the result using **REUSE_ALV_GRID_DISPLAY**, complete with a custom field catalog and descriptive column headers.

### `task04_discount_screen`  
Creates an interactive screen (`0100`) with input fields for order amount (Sipariş Tutarı), discount rate (İndirim Oranı), and customer type (Müşteri Tipi) as a dropdown: "Bireysel (Individual)" / "Kurumsal (Corporate)".  
Includes a **"Hesapla (Calculate)"** button and an output field to display the final amount.  
When the button is pressed, the program calculates the discounted total, and if the customer type is "Kurumsal (Corporate)", adds **1% KDV (VAT)** on top.  
The final calculated value is shown in the output field on the screen.

### `task05_single_selection_display`  
Creates a screen with three selectable options: "Sipariş Göster (Show Orders)", "Müşteri Göster (Show Customers)", and "Malzeme Göster (Show Materials)" using **radio buttons** (only one can be selected).  
Includes a **"Listele (List)"** button that displays the corresponding data based on the user's selection.  
Example data for each category is defined directly in the program.  
Displays the selected data on the screen, optionally using ALV formatting for structured output.

### `task06_alv_view_modes`  
Implements a screen with two radio button options: "Detaylı Görünüm (Detailed View)" and "Özet Görünüm (Summary View)", along with a **"Görüntüle (Display)"** button.  
Displays an **ALV report** based on the selected view mode.  
- If "Detaylı Görünüm (Detailed View)" is selected, shows a detailed ALV with 5 columns.  
- If "Özet Görünüm (Summary View)" is selected, shows a simplified ALV with only 2 columns.  
All data is defined directly within the program without using any database tables.

### `task07_exclusive_input_logic`  
Creates a program with a **selection screen block** that includes three fields: "Sipariş Numarası (Order Number)", "Müşteri Numarası (Customer Number)", and "Malzeme Numarası (Material Number)".  
Only one field can be filled by the user; the others become **inactive (SCREEN-ACTIVE = 0)** automatically using `LOOP AT SCREEN` logic.  
Depending on which field is filled, different data is displayed: for example, if only "Sipariş Numarası (Order Number)" is provided, corresponding order details are shown.  
All data is defined directly within the program (no database access).

### `task08_flight_alv_with_occupancy`  
Builds a **REUSE ALV** report that allows filtering flights by airline (`SFLIGHT-CARRID`) through a selection screen.  
The program calculates the seat occupancy percentage from `SEATSMAX/SEATSOCC` and adds it as a new column in the ALV.  
Flights with occupancy above 90% are automatically highlighted in red using `LINE_COLOR`.  
A custom toolbar button “Uçak Detayı (Aircraft Detail)” is added via `PF-STATUS` and `USER_COMMAND`.  
When the user selects a row and presses the button, the related aircraft type (`PLANETYPE`) is displayed in a popup window.  

### `task09_for_all_entries_salv_orders`  
Demonstrates efficient data fetching with a header–item relationship.  
Customer numbers are provided via a selection screen (`KNA1-KUNNR`).  
Matching sales orders are read from `VBAK`, and only if any exist, the corresponding items are fetched from `VBAP` using the **FOR ALL ENTRIES** technique.  
The program then merges header and item data and displays the result in an **SALV report** (with fallback to REUSE ALV if necessary).  

### `task10_custom_container_alv_mara`  
Implements a screen-based OO ALV report inside a custom container.  
Screen `0100` hosts a **CL_GUI_CUSTOM_CONTAINER** with an embedded **CL_GUI_ALV_GRID** created during PBO.  
Material data is read from `MARA` and displayed in the ALV with a manually built field catalog (`LVC_S_FCAT`) defining column order, headers, and widths.  
The layout (`LVC_S_LAYO`) is customized to include a report title “Malzeme Listesi (Material List)” and zebra striping for readability.  

### `task11_splitter_master_detail_alv`  
Creates a master–detail style UI using a **Splitter Container** with two ALV grids.  
The top ALV initially lists sales orders from `VBAK` (order number, customer number, date, etc.), while the bottom ALV starts empty.  
When the user double-clicks a row in the top ALV, the program reads the related items from `VBAP` and displays them in the bottom ALV.  
This provides an interactive drill-down between order headers and their items within a single screen.  

### `task12_editable_alv_with_save`  
Transforms an OO ALV into an editable data maintenance screen for a custom Z-table.  
The Z-table contains fields `MATNR`, `MAKTX`, and `UNAME1`, seeded with example data.  
In the ALV, the column “Malzeme Açıklaması (MAKTX)” is set as editable via the field catalog (`EDIT = 'X'`).  
A toolbar button “Değişiklikleri Kaydet (Save Changes)” is added.  
When users modify values and press Enter, the **`data_changed`** event is used to track edited rows.  
On pressing Save, only the changed rows are updated back to the Z-table with `UNAME1` filled from `sy-uname`, and a success message is displayed.  

### `task13_department_table_search_help`  
Implementation of a Department maintenance table with integrated Search Help and ALV reporting.  
A custom table is created (Department ID, Name, Manager, etc.) and maintained via `SM30`.  
A Search Help is defined in SE11 to allow users to search by department ID or name.  
In the ABAP program, the selection screen uses this Search Help, and selected data is displayed in an **ALV report** for better visualization.  

### `task14_bapi_salesorder_create`  
Creation of a Sales Order from ABAP using the standard BAPI `BAPI_SALESORDER_CREATEFROMDAT2`.  
The program provides a selection screen where the user enters customer number, material number, and quantity.  
These inputs are mapped into the required structures (`ORDER_HEADER_IN`, `ORDER_PARTNERS`, `ORDER_ITEMS_IN`) and passed to the BAPI.  
The result is checked in the RETURN table: successful calls display the new sales order number, while errors return descriptive messages.  

### `task15_custom_rfc_function_module`  
Development of a custom Remote Function Call (RFC) function module for external access.  
In SE37, a Z-function module is created under a function group and set as **Remote-Enabled**.  
The module receives a material number as input and retrieves details such as description and type from the MARA table.  
The information is returned through an export structure, enabling other SAP or external systems to call it via RFC.  

### `task16_adobeform_salesorder`  
Generating formatted PDF output for a sales order using Adobe Forms.  
The program accepts a sales order number as input, reads header data from VBAK and item data from VBAP, and passes them to an Adobe Form interface.  
Within `SFP`, interface parameters and context are defined, and the layout is designed with header fields and an item table.  
The final output is a PDF document that visually presents the sales order information directly from SAP.  

### `task17_ooalv_bapi_update_price`  
An integrated scenario combining OO ALV, editable fields, and material price updates with a BAPI.  
A report collects material information from MARA, MAKT, and MBEW tables and displays it in an **OO ALV Grid** (`CL_GUI_ALV_GRID`).  
The ALV includes an editable column “New Price” and a custom toolbar button “Update Price”.  
When triggered, the program processes the changed rows, calls `BAPI_MATERIAL_SAVEDATA` to update material prices, and provides immediate feedback in the ALV (green for success, red with error details).  
This exercise simulates a realistic business case for interactive data maintenance in SAP.  

## Notes

All programs in this repository were developed for learning purposes during an internship period.  
They demonstrate basic to intermediate ABAP logic and are intended for practice, experimentation, and educational use within a test or sandbox environment.
