# Bodeli Division Ledger Dashboard

Consumer ledger dashboard for MGVCL, Baroda O&M Circle, Bodeli O&M Division.

**Open the dashboard:** https://mayur007rathwa-lgtm.github.io/bodeli-ledger-dashboard/

## How to use

1. Open the dashboard and press **Upload LDG text file** (or drag and drop the file).
   Use the ledger text export, for example `034LDG102026.txt` (`|` separated, with the header row).
   Several subdivision files can be chosen together.
2. Search by consumer number, name or village, or by meter number.
3. Filter with the ▾ buttons (Excel style multi-select). Connection Date and PDC Date are grouped by month.
4. Press a Tariff card to filter the Consumer List by that tariff.
5. Export the filtered list with **Export Excel** (.xlsx, full list) or **Export PDF** (first 3,000 rows).

## Data privacy

The page contains no consumer data. The uploaded file is read only inside your own browser
and is never sent to any server or saved anywhere.

## Offline use

Download `index.html` from the latest release and open it in Chrome or Edge.

## Division master file from Google Drive

The Division admin keeps the latest LDG text files in one Google Drive folder. The
website reads them automatically on opening, so viewers do not need to upload.

1. Create a Drive folder and upload the latest LDG `.txt` files into it.
2. At script.google.com, create a project, paste `drive/Code.gs`, and set `FOLDER_ID`.
3. Deploy > New deployment > Web app (Execute as: Me, Who has access: Anyone).
4. Put the Web app URL in `window.BD_MASTER_URL` near the top of `index.html`.

Each month, replace the files in the Drive folder; the website picks them up on the next
opening. Note: anyone who has the website link can see the data it loads.
