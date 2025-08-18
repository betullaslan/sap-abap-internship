# SAP ABAP Internship Projects

This repository includes a variety of simple to intermediate ABAP reports and utility programs developed during my 2025 internship.  
The projects aim to strengthen basic ABAP skills through hands-on practice with commonly used programming structures, such as loops, conditions, parameters, and output formatting.

These exercises are suitable for beginners and early-stage learners looking to build a solid foundation in SAP ABAP development.

---

## Tasks Overview

### `task0_number_checks`  
Analyzes numbers from 0 to 100 by classifying them as even or odd and counting each type.  
Also lists numbers divisible by 2, 3, and 5, and checks where a user-input value falls within specific numeric ranges.

### `task1_calculator_fm`  
Implements a basic calculator using **Function Modules** in ABAP.  
Supports arithmetic operations (add, subtract, multiply, divide) with modular structure and user input handling.

### `task1_calculator_perform`  
A simple calculator program built using **FORM routines (`PERFORM`)** to organize arithmetic operations in a structured and reusable way.

### `task1_calculator_screen`  
Presents a basic **interactive screen (dynpro)** for the calculator using `SE51`.  
Includes input/output fields for numbers and operations, showcasing screen-based user interaction in ABAP.

### `task2_alv_order_list`  
Generates a structured **ALV (ABAP List Viewer)** report displaying a list of customer orders.  
Demonstrates usage of ALV functions to sort, filter, and format tabular data dynamically.

### `task3_material_alv_filter`  
Defines a material structure containing material number, description, and price fields.  
Initializes example data directly within the program and uses a **SELECT-OPTIONS** range to let the user specify a material number interval.  
Filters the internal table based on the user's input and displays the result using **REUSE_ALV_GRID_DISPLAY**, complete with a custom field catalog and descriptive column headers.

### `task4_discount_screen`  
Creates an interactive screen (`0100`) with input fields for order amount (Sipariş Tutarı), discount rate (İndirim Oranı), and customer type (Müşteri Tipi) as a dropdown: "Bireysel (Individual)" / "Kurumsal (Corporate)".  
Includes a **"Hesapla (Calculate)"** button and an output field to display the final amount.  
When the button is pressed, the program calculates the discounted total, and if the customer type is "Kurumsal (Corporate)", adds **1% KDV (VAT)** on top.  
The final calculated value is shown in the output field on the screen.

### `task5_single_selection_display`  
Creates a screen with three selectable options: "Sipariş Göster (Show Orders)", "Müşteri Göster (Show Customers)", and "Malzeme Göster (Show Materials)" using **radio buttons** (only one can be selected).  
Includes a **"Listele (List)"** button that displays the corresponding data based on the user's selection.  
Example data for each category is defined directly in the program.  
Displays the selected data on the screen, optionally using ALV formatting for structured output.

### `task6_alv_view_modes`  
Implements a screen with two radio button options: "Detaylı Görünüm (Detailed View)" and "Özet Görünüm (Summary View)", along with a **"Görüntüle (Display)"** button.  
Displays an **ALV report** based on the selected view mode.  
- If "Detaylı Görünüm (Detailed View)" is selected, shows a detailed ALV with 5 columns.  
- If "Özet Görünüm (Summary View)" is selected, shows a simplified ALV with only 2 columns.  
All data is defined directly within the program without using any database tables.

### `task7_exclusive_input_logic`  
Creates a program with a **selection screen block** that includes three fields: "Sipariş Numarası (Order Number)", "Müşteri Numarası (Customer Number)", and "Malzeme Numarası (Material Number)".  
Only one field can be filled by the user; the others become **inactive (SCREEN-ACTIVE = 0)** automatically using `LOOP AT SCREEN` logic.  
Depending on which field is filled, different data is displayed: for example, if only "Sipariş Numarası (Order Number)" is provided, corresponding order details are shown.  
All data is defined directly within the program (no database access).

### `task8_flight_alv_with_occupancy`  
Builds a **REUSE ALV** report that filters by airline(s) via **SELECT-OPTIONS** on `SFLIGHT-CARRID`.  
Calculates **seat occupancy %** from `SEATSMAX/SEATSOCC` and shows it as a new column.  
- Rows with **> 90% occupancy** are highlighted **red** (using `LINE_COLOR`).  
- Adds a custom toolbar button **“Uçak Detayı (Aircraft Detail)”** via `PF-STATUS` & `USER_COMMAND`.  
When the user selects a row and clicks the button, displays the flight’s **`PLANETYPE`** in a popup.  

### `task9_for_all_entries_salv_orders`  
Demonstrates efficient data fetching: first **headers**, then **details** only for those headers.  
- Takes **customer numbers** with **SELECT-OPTIONS** on `KNA1-KUNNR`.  
- Selects matching **sales orders** from `VBAK` into an internal table.  
- If any found, fetches corresponding **items** from `VBAP` using **`FOR ALL ENTRIES`**.  
- Merges header & item data and shows it in an **SALV** report (fallback to REUSE ALV if needed).  

### `task10_custom_container_alv_mara`  
Creates **Screen 100** with a **Custom Container** and embeds an **OO ALV Grid** (`CL_GUI_ALV_GRID`) in **PBO**.  
- Reads material data from **`MARA`**.  
- Builds field catalog manually with **`LVC_S_FCAT`** (order, headers, widths).  
- Sets layout via **`LVC_S_LAYO`**: title **“Malzeme Listesi (Material List)”** and **Zebra** pattern on.  

### `task11_splitter_master_detail_alv`  
Implements a **master–detail** UI using a **Splitter Container**: top ALV = **orders**, bottom ALV = **items**.  
- At start, top ALV lists `VBAK` (Order No., Customer No., Date…).  
- Bottom ALV is empty initially.  
- On **double-click** of a row in the top ALV, loads that order’s **`VBAP`** items and fills the bottom ALV.  

### `task12_editable_alv_with_save`  
Turns an **OO ALV** into a simple **editable** data maintenance screen for a custom **Z-table**.  
- Z-table fields: `MATNR`, `MAKTX`, `UNAME1`. Seed with sample data.  
- In ALV, **‘Malzeme Açıklaması (MAKTX)’** is **editable** (`EDIT = 'X'` in field catalog).  
- Adds a custom toolbar button **“Değişiklikleri Kaydet (Save Changes)”**.  
- On cell edits + Enter, handle **`data_changed`** event to **track changed rows** (no DB write yet).  
- On Save button, **update only changed rows** in the Z-table; set **`UNAME1 = sy-uname`**; show success message.  

---

## Notes

All programs in this repository were developed for learning purposes during an internship period.  
They demonstrate basic to intermediate ABAP logic and are intended for practice, experimentation, and educational use within a test or sandbox environment.
