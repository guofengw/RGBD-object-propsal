function [fgkids, bgkids] = m_assignGMM2pixels_3D(examples, fgGMMs, bgGMMs, fgIds, bgIds)
% Assign GMMs component id to each pixel by choosing the component which 
% has the minimum negative log likelihood of producing the pixel's color. 
% (do not consider the component weight here)
%

% Inputs:
% examples : N x 3 in color space
% fgGMMs: previous foreground GMMs
% bgGMMs: previous background GMMs
% fgIds: current foregroud pixel ids
% bgIds: current background pixel ids

% Outputs:
% fgkids: foreground pixel component ids
% bgkids: background pixel component ids


fgkids = m_assignment_Helper(examples(fgIds, :), fgGMMs);
bgkids = m_assignment_Helper(examples(bgIds, :), bgGMMs);

end

function  ids = m_assignment_Helper(examples, GMMs)
num_samples = size(examples, 1);
K = size(GMMs.mu, 2);
LogPL = zeros(num_samples, K);

for i = 1 : K
    if GMMs.wt(i) ~= 0
       LogPL(:,i) = m_GM_logPL_3D(examples, GMMs.mu(:,i), GMMs.detcov(i), GMMs.icov(:,:,i));
    else
       LogPL(:,i) = 1e4; 
    end
end 

[~, ids] = min(LogPL, [], 2);

end

