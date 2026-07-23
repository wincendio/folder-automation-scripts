# folder-automation-scripts

A collection of shell/Python scripts for performing **batch automated operations on files in the current working directory**.

Each script is self-contained and designed to be run from the folder you want to process — no installation required beyond the listed dependencies.

---

## 📂 Scripts

| Script | Description | Dependencies |
|--------|-------------|---------------|
| `pdf/batch_ocrmypdf.sh` | Add OCR layer to all PDFs in current folder | `ocrmypdf` |
| `video/batch_rename_mkv.py` | Batch rename `.mkv` files with a pattern | Python 3 |
| `video/batch_extract_audio.sh` | Extract audio track from all `.mkv` files | `ffmpeg` |
| `image/batch_resize_images.sh` | Resize all JPG/PNG images to a target width | `imagemagick` |

---

## 🚀 Usage

Navigate into any target folder, then run the desired script:

```bash
cd /path/to/your/folder
bash /path/to/script.sh
# or
python3 /path/to/script.py
```

---

## 📌 Conventions

- Scripts always operate on the **current working directory** (`$PWD` / `os.getcwd()`).
- Scripts are non-destructive by default: originals are kept and outputs go to an `output/` subfolder, unless otherwise noted.
- Each script prints progress to stdout.

---

## 🛠 Contributing

Feel free to add new scripts following the existing folder structure:

```
<file_type>/
  <action_description>.<sh|py>
```
