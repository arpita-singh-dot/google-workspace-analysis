import pypandoc
import os

# ensure pandoc is available
pypandoc.download_pandoc()

# go up one level from scripts/ to reach docs/
md_file = os.path.join(os.path.dirname(__file__), "..", "docs", "validation.md")
pdf_file = os.path.join(os.path.dirname(__file__), "..", "docs", "validation.pdf")

output = pypandoc.convert_file(
    md_file,
    "pdf",
    outputfile=pdf_file,
    extra_args=["--standalone"]
)

print(f"✅ PDF exported successfully: {pdf_file}")

