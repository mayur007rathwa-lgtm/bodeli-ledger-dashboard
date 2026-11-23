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

## Division master file (Supabase)

The Division admin signs in on the website and uploads the latest LDG text files. They are
stored in a private Supabase Storage bucket (`ledger`), and every signed-in viewer sees them
without uploading. Only the used columns are stored, gzip compressed.

1. Create a free Supabase project. In Authentication, turn off new user sign ups.
2. Add users in Authentication > Users (the admin login and the viewer logins, auto confirmed).
3. Put the admin email in `supabase/setup.sql` and run it in the SQL Editor.
4. Put the Project URL and the anon / publishable key in `BD_SUPABASE_URL` and
   `BD_SUPABASE_KEY` near the top of `index.html`. The anon key is meant to be public;
   the storage policies protect the data.
