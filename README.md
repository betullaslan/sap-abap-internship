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
- Supports arithmetic operations (add, subtract, multiply, divide)  
- Uses modular structure and user input handling  

### `task01_calculator_perform`  
A simple calculator program built using **FORM routines (`PERFORM`)** to organize arithmetic operations in a structured and reusable way.

### `task01_calculator_screen`  
Presents a basic **interactive screen (dynpro)** for the calculator using `SE51`.  
- Includes input/output fields for numbers and operations
- Showcases screen-based user interaction in ABAP 

### `task02_alv_order_list`  
Generates a structured **ALV (ABAP List Viewer)** report displaying a list of customer orders.  
Demonstrates usage of ALV functions to:  
- Sort  
- Filter  
- Format tabular data dynamically  

### `task03_material_alv_filter`  
Defines a material structure containing material number, description, and price fields.  
- Initializes example data directly within the program  
- Uses **SELECT-OPTIONS** to let the user specify a material number interval  
- Filters the internal table based on input  
- Displays result using **REUSE_ALV_GRID_DISPLAY** with custom field catalog and headers  

### `task04_discount_screen`  
Creates an interactive screen (`0100`) with:  
- Input fields for **Order Amount (Sipariş Tutarı)**, **Discount Rate (İndirim Oranı)**, and **Customer Type (Müşteri Tipi)**  
- Dropdown for customer type: "Bireysel (Individual)" / "Kurumsal (Corporate)"  
- A **"Hesapla (Calculate)"** button  
- An output field for the final amount  

Logic:  
- Calculates the discounted total  
- If customer type = Corporate → adds **1% KDV (VAT)**  
- Displays final value in the output field  

### `task05_single_selection_display`  
Creates a screen with three **radio buttons** (only one selectable):  
- "Sipariş Göster (Show Orders)"  
- "Müşteri Göster (Show Customers)"  
- "Malzeme Göster (Show Materials)"  

Includes a **"Listele (List)"** button to:  
- Display corresponding data (example data defined directly in the program)  
- Optionally use ALV formatting for structured output  

### `task06_alv_view_modes`  
Implements a screen with two radio button options: "Detaylı Görünüm (Detailed View)" and "Özet Görünüm (Summary View)", along with a **"Görüntüle (Display)"** button.  
Displays an **ALV report** based on the selected view mode.  
- If "Detaylı Görünüm (Detailed View)" is selected, shows a detailed ALV with 5 columns.  
- If "Özet Görünüm (Summary View)" is selected, shows a simplified ALV with only 2 columns.  
All data is defined directly within the program without using any database tables.

### `task07_exclusive_input_logic`  
Creates a selection screen block with three fields:  
- **Sipariş Numarası (Order Number)**  
- **Müşteri Numarası (Customer Number)**  
- **Malzeme Numarası (Material Number)**  

Logic:  
- Only one field can be filled → others become inactive (`SCREEN-ACTIVE = 0`)  
- Different data is displayed depending on which field is filled  
- All data is program-defined (no DB access)  

### `task08_flight_alv_with_occupancy`  
Builds a **REUSE ALV** report with airline filtering (`SFLIGHT-CARRID`).  

Features:  
- Calculates seat occupancy (`SEATSOCC / SEATSMAX`) → adds new column  
- Highlights occupancy >90% in **red** (`LINE_COLOR`)  
- Adds toolbar button **“Uçak Detayı (Aircraft Detail)”**  
- On row selection + button press → shows related `PLANETYPE` in a popup 

### `task09_for_all_entries_salv_orders`  
Demonstrates efficient data fetching with header–item relationship.  

Steps:  
- Customer numbers entered via selection screen (`KNA1-KUNNR`)  
- Matching sales orders read from `VBAK`  
- If any orders exist → items fetched from `VBAP` using **FOR ALL ENTRIES**  
- Header & item data merged and displayed in **SALV report** (fallback: REUSE ALV)  

### `task10_custom_container_alv_mara`  
Implements a screen-based OO ALV inside a **Custom Container**.  

- Screen `0100` hosts `CL_GUI_CUSTOM_CONTAINER` + embedded `CL_GUI_ALV_GRID`  
- Reads material data from `MARA`  
- Field catalog (`LVC_S_FCAT`) manually built (column order, headers, widths)  
- Layout (`LVC_S_LAYO`) customized:  
  - Report title “Malzeme Listesi (Material List)”  
  - Zebra striping for readability  

### `task11_splitter_master_detail_alv`  
Creates a **master–detail UI** using a Splitter Container with two ALV grids.  

- **Top ALV**: lists sales orders from `VBAK` (order no, customer, date, etc.)  
- **Bottom ALV**: starts empty  
- On double-clicking a row in the top ALV → related items from `VBAP` are shown in the bottom ALV  

This enables an interactive drill-down between order headers and items on one screen.  

### `task12_editable_alv_with_save`  
Transforms an OO ALV into an **editable data maintenance screen** for a custom Z-table (`MATNR`, `MAKTX`, `UNAME1`).  

- Example data seeded into the Z-table  
- Column **“MAKTX”** set as editable (`EDIT = 'X'`)  
- Toolbar button: **"Değişiklikleri Kaydet (Save Changes)"**  
- **`data_changed`** event tracks modified rows  
- On Save:  
  - Only changed rows are updated in the Z-table  
  - `UNAME1` automatically filled from `sy-uname`  
  - Success message displayed  

### `task13_department_table_search_help`  
Implements a **Department maintenance table** with integrated Search Help and ALV reporting.  

- Custom table created (Department ID, Name, Manager, etc.) and maintained via `SM30`  
- **Search Help** defined in SE11 to search by department ID or name  
- Program selection screen uses this Search Help  
- Selected data displayed in an **ALV report** for clearer visualization  

### `task14_bapi_salesorder_create`  
Creates a Sales Order from ABAP using the standard BAPI `BAPI_SALESORDER_CREATEFROMDAT2`.  

- Selection screen: user enters **customer number, material number, and quantity**  
- Inputs mapped into structures: `ORDER_HEADER_IN`, `ORDER_PARTNERS`, `ORDER_ITEMS_IN`  
- BAPI called with these inputs  
- RETURN table checked:  
  - On success → new sales order number displayed  
  - On error → descriptive messages returned  

### `task15_custom_rfc_function_module`  
Develops a custom **Remote Function Call (RFC) function module** for external access.  

- Created in SE37 under a function group and set as **Remote-Enabled**  
- Input: material number  
- Retrieves details (description, type) from `MARA`  
- Returns information via an export structure  
- Can be called by other SAP or external systems through RFC  

### `task16_adobeform_salesorder`  
Generates a formatted **PDF sales order** using Adobe Forms.  

- Input: sales order number  
- Reads header data from `VBAK` and item data from `VBAP`  
- Passes data to an Adobe Form interface (`SFP`)  
- In `SFP`: interface parameters, context, and layout (header fields + item table) are defined  
- Output: PDF document that presents sales order information directly from SAP  

### `task17_ooalv_bapi_update_price`  
An integrated scenario combining OO ALV, editable fields, and BAPI-based price updates.  

- Report collects material data from `MARA`, `MAKT`, and `MBEW`  
- Displays results in an **OO ALV Grid** (`CL_GUI_ALV_GRID`)  
- ALV features:  
  - Editable column **“New Price”**  
  - Toolbar button **“Update Price”**  
- On trigger:  
  - Processes changed rows  
  - Calls `BAPI_MATERIAL_SAVEDATA` to update material prices  
  - Provides immediate feedback in ALV → green = success, red = error with details  

This simulates a realistic business case for interactive data maintenance in SAP.  

## Notes

All programs in this repository were developed for learning purposes during an internship period.  
They demonstrate basic to intermediate ABAP logic and are intended for practice, experimentation, and educational use within a test or sandbox environment.
