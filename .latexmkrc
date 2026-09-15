# .latexmkrc - Cross-platform configuration for LuaLaTeX and bib2gls

# Set default engine to LuaLaTeX
$pdf_mode = 4;
$postscript_mode = $dvi_mode = 0;

# Centralize auxiliary files (supported natively by TeX Live & MikTeX)
$aux_dir = 'tmp';
$out_dir = '%OUTDIR%';

# Custom dependency rule: When an .aux file references a glossary,
# bib2gls reads tmp/<base>.aux and outputs tmp/<base>.glstex
add_cus_dep('aux', 'glstex', 0, 'run_bib2gls');

sub run_bib2gls {
    my ($base) = @_;
    # Using list format in system() bypasses the Windows/Linux shell quirks
    # and executes the binary directly in the system PATH
    return system('bib2gls', '--dir', $aux_dir, $base);
}

# Tell latexmk to track and clean these generated files
push @generated_exts, 'glstex', 'glg', 'log';