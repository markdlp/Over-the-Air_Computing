# report/.latexmkrc
use File::Basename;

$pdf_mode = 4;
$postscript_mode = $dvi_mode = 0;

$aux_dir = 'tmp';
$out_dir = 'tmp';

# %O passes all directory and mode flags; %S passes the target .tex file
$lualatex = 'lualatex -synctex=1 -interaction=nonstopmode -file-line-error -shell-escape %O %S';

# bib2gls custom dependency
add_cus_dep('aux', 'glstex', 0, 'run_bib2gls');

sub run_bib2gls {
    my ($name, $path) = fileparse($_[0]);
    if ($path eq './' or $path eq '') {
        return system('bib2gls', $name);
    } else {
        $path =~ s{[\/\\]+$}{};
        return system('bib2gls', '--dir', $path, $name);
    }
}

push @generated_exts, 'glstex', 'glg';