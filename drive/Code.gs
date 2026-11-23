/**
 * Bodeli Division Ledger Dashboard - master file link.
 *
 * Reads the LDG text files (.txt) kept in one Google Drive folder and sends
 * the columns the dashboard uses. Deploy as a Web app:
 *   Execute as: Me    Who has access: Anyone
 * Then paste the Web app URL into BD_MASTER_URL in index.html.
 */
const FOLDER_ID = 'PASTE_FOLDER_ID_HERE';

const KEEP = ['MONTH', 'YEAR', 'CONSUMER_NO', 'CONSUMER_NAME', 'SUBDIV_NAME', 'VILLAGE_NAME',
  'TARRIF_SHORT', 'TARRIF', 'FEEDER_NAME', 'FEEDER_NO', 'METER_STATUS', 'SOLAR_CONSUMER',
  'CONTRACT_LOAD', 'CONSUMPTION_UNIT', 'THEFT_ARREARS', 'LITIGATION_ARREARS', 'METER_NO',
  'ADDRESS1', 'ADDRESS2', 'CENCUS_CODE', 'CENSUS_CODE', 'TRANS_LOCATION', 'CONNECTION_DATE', 'PDC_DATE'];

function doGet() {
  try {
    const files = [];
    const it = DriveApp.getFolderById(FOLDER_ID).getFiles();
    while (it.hasNext()) {
      const f = it.next();
      if (!/\.txt$/i.test(f.getName())) continue;
      const blob = f.getBlob();
      let text = blob.getDataAsString('UTF-8');
      if (text.indexOf('�') >= 0) text = blob.getDataAsString('windows-1252');
      files.push({ name: f.getName(), updated: f.getLastUpdated().toISOString(), text: trimColumns(text) });
    }
    files.sort(function (a, b) { return a.name < b.name ? -1 : 1; });
    return out({ files: files });
  } catch (e) {
    return out({ error: String(e && e.message || e) });
  }
}

/** Keeps only the columns the dashboard reads, so the page loads fast. */
function trimColumns(text) {
  const lines = text.split(/\r?\n/);
  const head = (lines[0] || '').replace(/^﻿/, '');
  const sep = head.indexOf('|') >= 0 ? '|' : head.indexOf('\t') >= 0 ? '\t' : ',';
  const cols = head.split(sep).map(function (s) { return s.trim().toUpperCase(); });
  const idx = [];
  cols.forEach(function (c, i) { if (KEEP.indexOf(c) >= 0) idx.push(i); });
  const res = [];
  for (let k = 0; k < lines.length; k++) {
    if (!lines[k].trim()) continue;
    const f = k === 0 ? cols : lines[k].split(sep);
    res.push(idx.map(function (i) { return f[i] === undefined ? '' : f[i]; }).join('|'));
  }
  return res.join('\n');
}

function out(obj) {
  return ContentService.createTextOutput(JSON.stringify(obj)).setMimeType(ContentService.MimeType.JSON);
}
