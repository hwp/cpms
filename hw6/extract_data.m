d = load('2016-CPMS-HW6signdata.mat');
d = d.signdata;
cls = d.cls;
save 'data/cls.mat' cls
sbj = d.sbj;
save 'data/sbj.mat' sbj
feats = d.feats;
for i = 1:size(feats)
  feat = feats{i};
  save(sprintf('data/feat_%d.mat', i), 'feat')
end

