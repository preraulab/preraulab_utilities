function packagecode(fname,dest, toponly)
if nargin < 3
    toponly = true;
end
if toponly
    filelist=matlab.codetools.requiredFilesAndProducts(fname, 'toponly');
else
    filelist=matlab.codetools.requiredFilesAndProducts(fname);
end

mkdir(dest);
for i=1:length(filelist)
    copyfile(filelist{i},dest);
end
