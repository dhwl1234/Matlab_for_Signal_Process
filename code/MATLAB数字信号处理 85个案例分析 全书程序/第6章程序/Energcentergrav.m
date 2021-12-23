function Z=Energcentergrav(x,fs,NX,nord)
if nargin<3, NX=[0 fs/2]; nord=3; end  % 设定缺省值
if nargin<4, nord=3; end
if isempty(NX), NX=[0 fs/2]; end
x=x(:)';                               % 输入数据成行序列
Z=zeros(1,3);                          % 初始化
N=length(x);                           % 数据长度
wind=hanning(N,'periodic');            % 生成海宁窗
X=fft(x.*wind');                       % FFT
k_cor=2.667;                           % 海宁窗恢复系数 
X=X(1:N/2+1)/N*2;                      % 单边复数谱
df=fs/N;                               % 频率分辨率
n1=floor(NX(1)/df)+1;                  % 对NX求出对应谱线的索引号
n2=floor(NX(2)/df)+1;
X_abs=abs(X);                          % 单边幅值谱
XP=X_abs.^2;                           % 单边功率谱
[vl,kmax]=max(XP(n1:n2));              % 寻找功率最大值
kmax=kmax+n1-1;                        % 调整最大值索引号
phmax=angle(X(kmax));                  % 最大值处对应的相位  
dn=-nord:nord;                         % 设置求和的区间
f_cor=sum((kmax+dn).*XP(kmax+dn))/sum(XP(kmax+dn)); % 按式(6-3-9)求x0      
Z(1)=(f_cor-1)*df;                     % 频率校正
Z(2)=sqrt(k_cor*sum(XP(kmax+dn)));     % 按式(6-3-10)幅值校正            
Z(3)=phmax+pi*(kmax-f_cor);            % 按式(6-3-13)相位校正
Z(3)=mod(Z(3),2*pi);                   % 把相角限在[-pi,pi]区间内 
Z(3)=Z(1,3)-(Z(3)>pi)*2*pi+(Z(3)<-pi)*2*pi; 