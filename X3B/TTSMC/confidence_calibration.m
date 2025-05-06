% Prompt the user to select a file
[filename, path] = uigetfile('*.txt', 'Select a data file');
if isequal(filename,0)
    error('No file selected')
else
    filepath = fullfile(path,filename);
end

% Extract columns from the data
trial = data(:,1);
stimulus = data(:,2);
correct = data(:,3);
confidence = data(:,4);

% Calculate the mean confidence for each stimulus
stimulus_values = unique(stimulus);
mean_confidence = zeros(size(stimulus_values));
for i = 1:length(stimulus_values)
    idx = stimulus == stimulus_values(i);
    mean_confidence(i) = mean(confidence(idx));
end

% Calculate the proportion correct for each stimulus
proportion_correct = zeros(size(stimulus_values));
for i = 1:length(stimulus_values)
    idx = stimulus == stimulus_values(i);
    proportion_correct(i) = sum(correct(idx)) / sum(idx);
end

% Calculate the degree of overconfidence or underconfidence
z_score = norminv(proportion_correct) - norminv(mean_confidence);
overconfidence = z_score > 0;
underconfidence = z_score < 0;

% Display the results
disp(['Number of trials: ' num2str(length(trial))]);
disp(['Number of stimuli: ' num2str(length(stimulus_values))]);
disp(['Degree of overconfidence: ' num2str(sum(overconfidence))]);
disp(['Degree of underconfidence: ' num2str(sum(underconfidence))]);
