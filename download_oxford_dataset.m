function datasetPath = download_oxford_dataset()
% DOWNLOAD_OXFORD_DATASET  Download Oxford Battery Degradation Dataset 1 (.mat)
%   datasetPath = download_oxford_dataset()
%
%   Downloads the .mat dataset file from Oxford's repository if not
%   already stored locally. Returns the full path to the .mat file.
%
%   Source DOI: 10.5287/bodleian:KO2kdmYGg
%   Direct URL:
%   https://ora.ox.ac.uk/objects/uuid:03ba4b01-cfed-46d3-9b1a-7d4a7bdf6fac/files/m5ac36a1e2073852e4f1f7dee647909a7

    % Direct .mat download URL
    matURL = "https://ora.ox.ac.uk/objects/uuid:03ba4b01-cfed-46d3-9b1a-7d4a7bdf6fac/files/m5ac36a1e2073852e4f1f7dee647909a7";

    % Expected local filename
    matName = "Oxford_Battery_Degradation_Dataset_1.mat";
    datasetPath = fullfile(pwd, matName);

    % If file exists, skip download
    if isfile(datasetPath)
        fprintf("✓ Dataset already exists: %s\n", datasetPath);
        return
    end

    % Attempt download
    fprintf("⬇ Downloading Oxford Battery Degradation Dataset 1...\n");
    try
        websave(matName, matURL);
    catch ME
        error("Download failed: %s", ME.message);
    end

    % Confirm the file was downloaded
    if ~isfile(datasetPath)
        error("Download completed but file not found: %s", datasetPath);
    end

    fprintf("✅ Dataset successfully downloaded to: %s\n", datasetPath);
end
