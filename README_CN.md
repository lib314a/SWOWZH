[<img src="https://smallworldofwords.org/img/logos/SWOW_Tag_Wide.png"/>](SWOW)

# 目录

1.  [关于 Small World of Words 项目（SWOW）及 SWOW-ZH](#orga7a1ee6)
2.  [数据集下载](#xCnQ)
3.  [仓库使用说明](#org6423954)
    1.  [获取数据](#org008856a)
    2.  [原始数据](#org1a6cd57)
    3.  [MATLAB语言与R语言](#org428qfma2)
    4.  [预处理脚本](#orgc0ba651)
    5.  [处理脚本](#orga56d790)
        1.  [联想频率与网络](#org8eea69f)
        2.  [派生统计](#orgdff87ab)
        3.  [中心性与相似度](#org11b9387)
    6.  [SWOW-GPT 的收集、预处理与处理](#orga8bvv1)
    7.  [在其他语言的 SWOW 词库中的适用性](#org511e306)
4.  [基于 SWOW 的出版物](#org124b364)

<a id="orga7a1ee6"></a>

# 关于 [Small World of Words 项目（SWOW）](https://smallworldofwords.org/project/) 及 SWOW-ZH

Small World of Words 项目是一项大规模科学研究，旨在构建世界语言的心理词典（mental dictionary）或词汇库（lexicon），并广泛公开这些信息
<sup><a id="fnr.1" class="footref" href="#fn.1" role="doc-backlink">1</a></sup>。

与词典不同，我们使用词语联想（word associations）来了解词语的含义以及哪些词在人的大脑中处于核心地位。这使得心理学家、语言学家、神经科学家等能够测试关于我们如何表征和处理语言的新理论。这些知识还可以应用于多种领域，从了解文化差异，到学习（或遗忘）第一语言或第二语言的新词汇。

SWOW-ZH 是 SWOW 的一个子项目，旨在绘制汉语的心理词汇网络，其中后缀 `ZH` 代表 *Zhongwen*（中文）。该项目旨在提供一个全面的框架，用以测量与中国文化和中国人相关的心理词汇，并为中英文及其他语言之间的比较研究奠定基础。

我们采用的参与者任务称为*多联想任务*（multiple response association）
<sup><a id="fnr.2" class="footref" href="#fn.2" role="doc-backlink">2</a></sup>。该任务中，参与者看到一个提示词后，需要给出三个与该提示词相关联的词。随着参与者数量的增加，词汇库得以全面且高效地代表心理词典。因此，该方法聚焦于人们共享的词义方面，而不限定词义必须来自哪方面。

汉语是一种在人口和文化上都极为复杂的语言，其方言和书写系统也很多样。因此，在 SWOW-ZH 项目中，我们主要*聚焦于普通话*（普通话，Putonghua）及简体中文书写系统，这些是中国大陆大部分地区使用的语言和书写体系。同时，参与者的母语方言也被收集作为补充信息。另一个聚焦于粤语的 SWOW 子项目 [SWOW-HK](https://smallworldofwords.org/hk) 也许会引起您的兴趣。

-   本研究由华东师范大学心理与认知科学学院蔡清教授团队主持，与墨尔本大学 Simon De Deyne 博士合作完成。Simon De Deyne 博士在鲁汶大学（University of Leuven）Gert Storms 教授指导下创立了 SWOW 项目。

-   如有疑问或建议，请联系：

    -   丁子益 \| DING Ziyi \|  
        [ziyi.ecnu@gmail.com](mailto:ziyi.ecnu@gmail.com) \|  
        [ZiyiDing7@github](https://github.com/ZiyiDing7)
    -   李兵 \| LI Bing \|  
        [lbing314@gmail.com](mailto:lbing314@gmail.com) \|  
        [lib314a@github](https://github.com/lib314a)

-   机构：

    -   上海脑功能基因组学重点实验室（教育部）、华东师范大学附属心理健康中心、脑与教育创新研究院、华东师范大学心理与认知科学学院，中国上海
    -   上海脑科学与类脑技术研究中心，中国上海

-   致谢：

    -   本工作由中国国家自然科学基金（项目编号31970987，蔡清教授）及澳大利亚研究理事会早期职业研究基金（DE140101749，Simon De Deyne）资助。

-   数据许可：  
    详见 https://smallworldofwords.org/en/project/

-   代码许可：  
    <a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />本作品采用<a rel="license" href="http://creativecommons.org/licenses/by/4.0/">知识共享署名 4.0 国际许可协议</a>进行许可。

-   引用格式：  
    -   `APA`: Li, B., Ding, Z., De Deyne, S., & Cai, Q. (2024). A large-scale database of Mandarin Chinese word associations from the Small World of Words Project. _Behavior Research Methods, 57_(1), 34. http://dx.doi.org/10.3758/s13428-024-02513-1
    -   `bibtex`:
    ```bibtex
      @article{li_large-scale_2024,
	title = {A large-scale database of {Mandarin} {Chinese} word associations from the {Small} {World} of {Words} {Project}},
	volume = {57},
	issn = {1554-3528},
	url = {https://link.springer.com/10.3758/s13428-024-02513-1},
	doi = {10.3758/s13428-024-02513-1},
	language = {en},
	number = {1},
	urldate = {2025-01-02},
	journal = {Behavior Research Methods},
	author = {Li, Bing and Ding, Ziyi and De Deyne, Simon and Cai, Qing},
	month = dec,
	year = {2024},
	pages = {34},
    }
    ```

<a id="xCnQ"></a> 

# 下载数据集

可从网页获取数据集：<https://smallworldofwords.org/zh/project/research>

-   更新时间：2024年11月4日

<a id="orgec4a5fe"></a>

# 仓库使用说明

*提示：与其在浏览器中浏览仓库，不如将其下载到本地更方便。*

在本仓库中，您将找到一个针对汉语SWOW项目的基础分析流程，包括导入数据、预处理、计算词汇或词间关系的指标，另外还包括一些基础的统计。

<a id="org008856a"></a>

## 获取数据

除了脚本之外，您还需要获取词语联想数据。目前，词语联想及参与者数据覆盖了10,192个提示词。数据包含了2016年至2023年间收集的超过200万个联想响应。这些数据目前已经投稿发表。如果您想将这些数据用于自己的研究，可以从Small World of Words研究页面获取（<https://smallworldofwords.org/zh/project/research>）。

要启动分析流程，应将`SWOW-ZH_raw.(csv|mat)`放入data文件夹中。

虽然大部分数据是在[SWOW平台（ZH）](https://smallworldofwords.org/zh)收集的，但部分数据是在另一个中国线上实验平台[NAODAO（脑岛）](https://www.naodao.com)上使用相同任务和相同纳入标准收集的。这不会影响数据的可靠性。

如果您觉得这些数据有用，请考虑分享词语联想研究给更多人（<https://smallworldofwords.org/zh/project>）。

<a id="org1a6cd57"></a>

## 原始数据

由于这是一个持续进行的项目，数据会定期更新。因此，所有数据文件名中均包含发布日期。您需要根据README重命名数据，使得代码可以正常读取数据。

1.  SequenceNumber：系统编码，按顺序从1递增。

2.  TrialsID：试次的唯一标识符。每个试次由一个提示词和三个联想响应组成。

3.  ParticipantID：参与者的唯一标识符。

4.  Created_at：试次完成的时间和日期。

5.  Age：参与者报告的年龄。

6.  NativeLanguage：参与者报告的方言及普通话。

    -   NAODAO平台中的标签：
        -   PUTON：普通话，是官方推广的标准发音（普通话）；
        -   SOUTHE：东南方言，代表福建北部及南部方言，覆盖福建大部、潮汕、海南及台湾（东南部方言：代表为包括闽北及闽南方言，覆盖福建大部及潮汕、海南及台湾）；
        -   NORTH：北方方言，代表东北三省及内蒙古方言、冀豫鲁、胶东、辽东和汉水流域北部（北方方言：代表为东北三省及内蒙方言、冀豫鲁、胶东、辽东和汉水流域北部）；
        -   SOUTH：南部方言，代表广西、广东、海南的平话、白话，以及香港和澳门的粤语（南部方言：代表为包括广西、广东和海南的平话、白话，及香港和澳门的粤语）；
        -   JIANG：江淮方言，代表江淮流域及苏北、鲁南（江淮方言：代表为江淮流域及苏北、鲁南）；
        -   SHAN：陕、晋方言，代表陕西及山西各地（陕、晋方言：代表为陕西及山西各地）；
        -   HAKKA：客家话，分布在全国各地的客家族语（客家话：代表为分布在各地的客家族语）；
        -   SOUTHW：西南方言，代表云贵川、湖北和湖南大部（西南方言：代表为云贵川鄂湘大部）；
        -   WU：吴方言，代表江西和安徽东部、浙江大部及上海（吴方言：代表为江西和安徽东部、浙江大部及上海）；
        -   NORTHW：西北方言，代表银川、兰州和西宁（西北方言：代表为银川、兰州、西宁）。
    -   SWOW平台中的标签：
        -   PUTON：与NAODAO相同；
        -   EASTW：与NAODAO中的WU相同；
        -   JIANG：与NAODAO相同；
        -   SHAN：与NAODAO相同；
        -   HAKKA：与NAODAO相同；
        -   NORTH：合并了NAODAO中的NORTH和NORTHW；
        -   SOUTH：合并了NAODAO中的SOUTHE、SOUTHW和SOUTH。

7.  Gender：参与者性别（Female / Male / X），包括女性、男性和非二元性别。

8.  Education：参与者选择的教育水平：1 = 无，2 = 小学，3 = 高中，4 = 大学本科，5 = 硕士。

9.  City：测试时所在城市，可能为近似值。

10. Country：测试时所在国家。

11. Section：数据来源及滚雪球迭代标识：set1至10 = SWOW平台收集的十个轮次，NAODAO = NAODAO平台收集的一个轮次（<https://smallworldofwords.org/zh/project/research>）。

12. Cue：提示词。

13. R1Raw：原始第一个联想响应。

14. R2Raw：原始第二个联想响应。

15. R3Raw：原始第三个联想响应。

16. R1：第一个联想响应。

17. R2：第二个联想响应。

18. R3：第三个联想响应。

<a id="org428qfma2"></a>

## MATLAB语言与R语言

脚本有R语言与MATLAB语言两种版本。MATLAB脚本直接存储在主文件夹`SWOWZH-main`内，R脚本存储在文件夹`SWOWZH-main/scripts内`。_请勿更改代码路径。_

为了避免MATLAB读取中文字符串时可能出现的错误，建议将所有数据以`mat`格式加载和保存。我们也提供了`csv`格式的数据，方便其他编程语言用户使用。

<a id="orgc0ba651"></a>

## 预处理脚本

预处理脚本包括`wordCleaning.(m|R)`、`participantCleaning.(m|R)`和`dataBalancing.(m|R)`。

`wordCleaning.(m|R)`：根据词典标记或修改有问题的提示词和联想响应。词典位于data/dictionaries文件夹，且可编辑。脚本输入文件`SWOW-ZH_raw.mat`应放置在data文件夹中。

### 词典说明

1. `tradCues.(txt|mat)`和`tradRes.(txt|mat)`：基于Open Chinese Convert库，将繁体中文提示词和联想响应转换为简体中文，`ropencc`包可从(<https://github.com/Lchiffon/ropencc>)获取。

2. `englishRes.(txt|mat)`：常见的普通话中使用的英文联想响应，已修正大小写。

3. `unsplitedRes.(txt|mat)`：被错误合并的联想响应，指参与者在一个响应框内输入了两个或多个响应，但是参与者使用了标点或符号（如逗号、空格、加号、停顿符号）分隔，已被依次拆分为单独联想响应，仅保留前三个。

4. `longRes.(txt|mat)`：长度超过六个字符的长联想响应标记为#Long，除非该长词至少出现两次且有意义。无意义的长联想响应定义为需要添加或删除至少一个字符才能成为短语的字符串。

5. `symbolRes.(txt|mat)`：包含非中文字符（字母、符号、数字和/或标点）的联想响应，若有意义且出现超过一次则保留并修改，其他标记为#Symbol。

6. `erRes.(txt|mat)`：儿化音（erhua或erization），即某些音节末尾的-er（儿）发音特征，从联想响应中删除。

7. `SWOWZHwordlist.mat`：合并自SUBTLEX-CH<sup><a id="fnr.3" class="footref" href="#fn.3" role="doc-backlink">3</a></sup>和Chinese Web 5-gram版本1的Unigram子集<sup><a id="fnr.4" class="footref" href="#fn.4" role="doc-backlink">4</a></sup>的中文词表。在参与者清理阶段，词表中未包含的联想响应视为非词。

`participantCleaning.(m|R)`：删除有问题的参与者。

`dataBalancing.(m|R)`：每个提示词下保留55名参与者。脚本输出写入data/SWOW-ZH_R55.mat。参与者选择偏向于保留哪些报告了更多联想的参与者，以及普通话使用者。预处理后的数据可在Small World of Words研究页面获取（<https://smallworldofwords.org/zh/project/research>）。

### 关于繁体字处理的*注意事项*

繁体转简体使用了OpenCC库（详见[Open Chinese Convert 開放中文轉換](https://github.com/BYVoid/OpenCC)）。`R`用户可使用名为[ropencc](https://github.com/Lchiffon/ropencc)的OpenCC移植包，示例代码如下：
```r
CONVERTER <- ropencc::converter(ropencc::T2S)
CONVERTER["詞彙"]
[1] "词汇"
```

<a id="orga56d790"></a>

## 处理脚本

处理脚本包括MATLAB的`networkGeneration.m`、`frequencyCalculating.m`、`centralityCalculating.m`和`similarityCalculating.m`。对应的R脚本改编自SWOW-EN，包括`createSWOWGraph.R`、`createAssoStrengthTable.R`、`createResponseStats.R`、`createCueStats.R`和`createNetworkStatistics.R`。

此外，`gradientValidation.m`用于验证样本量对预测关联性判断任务的影响<sup><a id="fnr.5" class="footref" href="#fn.5" role="doc-backlink">5</a></sup>。

<a id="org8eea69f"></a>

### 联想频率与网络

-   `networkGeneration.m`：使用预处理数据计算联想频率（即给定提示词的响应条件概率），结果保存在output文件夹，文件名为assocFrequency_R1或_R123，第一列为提示词，第二列为联想响应，第三列为它们之间的联想频率。基于第一个联想响应（R1）或所有三个联想响应（R123），提取最大强连通分量的网络。网络保存为data/SWOW-ZH_network.mat。邻接矩阵保存为output文件夹下的adjacencyMatrix_R1或_R123，包含有向加权矩阵，行标为N个提示词，列标为N个响应，矩阵元素为归一化的联想强度。通常需将联想频率除以该提示词所有强度之和以转换为联想强度。未包含在最大连通分量的顶点在output文件夹的lostNodes_R1或_R123报告中列出。
-   `createSWOWGraph.R`和`createAssoStrengthTable.R`功能与`networkGeneration.m`相同。

<a id="orgdff87ab"></a>

### 派生统计

-   `frequencyCalculating.m`：用于描述联想响应、提示词和参与者的特征。

1.  联想响应统计

> 当前脚本计算三种联想想用的频率指标：词汇类型（type）、词频总数（tokens）以及仅被报告过一次的联想响应（hapax legomena）。结果保存在output文件夹的resStats中。

2.  提示词统计

> 仅考虑属于强连通分量的提示词。结果分别针对R1图和R123图提供，保存在output文件夹的cueStats_R1或_R123中。文件包含：

-   覆盖率：在剔除非提示词或非最大强连通分量词后，图中保留的联想响应比例。

-   未知联想响应数

-   R1缺失联想响应数

-   R2缺失联想响应数

-   R3缺失联想响应数

> 可通过frequencyCalculating.m脚本获得R1和R123图的联想响应覆盖率直方图。词汇增长曲线可通过`scripts/as-vocabulary-growth.R`获得。

-   `createResponseStats.R`和`createCueStats.R`功能与`frequencyCalculating.m`相同。

<a id="org11b9387"></a>

### 中心性与相似度

-   `centralityCalculating.m`：基于最大强连通分量图，计算中心性指标，包括词汇类型和词频总数、入度、出度、PageRank系数、聚类系数、中心性和介数中心性。脚本调用了Brain Connectivity Toolbox (BCT) (<http://www.brain-connectivity-toolbox.net>)中的部分函数。输出保存在output文件夹的centrality_R1或_R123中。

-   `similarityCalculating.m`：基于最大强连通分量图，计算四种相似度：余弦相似性（AssocStrength）、正点互信息（PPMI）、随机游走（RW）及随机游走后词嵌入（RW-embedding）。脚本改编自SWOW-EN和SWOW-RP。输出保存在output文件夹的similarity_R1或_R123中。

-   `createNetworkStatistics.R`功能与`centralityCalculating.m`相同。

<a id="org511e306"></a>

### 样本量验证

`gradientValidation`：基于参与者清理后的原始数据（`SWOW-ZH_partcleaning.m`），完成验证时需将相关性判断任务的行为数据放入data文件夹。样本量针对具体词从每提示词20名扩展至80名，针对抽象词从20名扩展至120名。

## SWOW-GPT的收集、预处理与处理
<a id="orga8bvv1"></a>

通过OpenAI API使用GPT-3.5-turbo执行三响应自由联想任务，称为*SWOW-GPT*。为确保与人类数据的可比性，采用了相同的预处理和处理步骤。

在SWOW-GPT文件夹中：
- 脚本`WS_gpt.html`包含对GPT-3.5-turbo生成联想的指令和参数；
- 预处理和处理脚本（MATLAB）组织结构与SWOW-ZH的预处理脚本相似。

### SWOW-GPT原始数据

`SWOW-GPT_raw.(mat|csv)`包含四列：Cue、R1Raw、R2Raw和R3Raw，分别代表发送给GPT-3.5-turbo的提示词及其对应的三个响应。

### SWOW-GPT预处理脚本

预处理脚本包括`wordCleaning.m`和`dataBalancing.m`。

`wordCleaning.m`：根据词典内标记或修改有问题的提示词和联想响应。词典位于SWOW-GPT/data/dictionaries文件夹，词典均可编辑。脚本输入文件`SWOW-GPT_raw.mat`应放在SWOW-GPT/data文件夹。

`dataBalancing.m`：将GPT-3.5-turbo的联想嵌入人类SWOW-ZH数据中，每个提示词保留55名参与者。脚本输入包括SWOW-GPT/data文件夹中的`SWOW-ZH_partcleaning.mat`。输出写入data/SWOW-GPT_R55.mat。参与者选择偏向缺失联想响应较少的试次。

### SWOW-GPT处理脚本

处理脚本包括`networkGeneration.m`、`similarityCalculating.m`和`gradientValidation.m`。

`[2026-04-30 Thu]` `SWOW-GPT/`子目录中已更新GPT-4o脚本。


## 其他SWOW词库的适用性

鉴于其他SWOW词库主要通过R脚本处理，现提供MATLAB脚本以便用MATLAB处理其他SWOW词库。`SWOWs.m`用于计算联想频率、生成网络及计算入度。脚本输入为放置于data/SWOWs文件夹中的其他SWOW词库预处理数据。输出为网络，保存至data/SWOWs/SWOW-XX_network.mat，其中XX可替换为EN（美式英语）、NL（荷兰语）和RP（里约普拉滕斯西班牙语）。输出可作为`centralityCalculating.m`和`similarityCalculating.m`的输入。

<a id="org124b364"></a>

# 基于SWOW的出版物

以下参考文献基于本词库，或者部分使用了本词库：

-   期刊文献
    -   Cox, C. R., & Haebig, E. (2023). Child-oriented word
        associations improve models of early word learning. *Behavior Research Methods, 55*(1), 16–37. <https://doi.org/10.1037/0033-295X.82.6.407>
    -   De Deyne, S., Navarro, D. J., Collell, G., & Perfors, A. (2021).
        Visual and affective multimodal models of word meaning in
        language and mind. *Cognitive Science, 45*(1), 12922. <https://doi.org/10.1111/cogs.12922>
    -   De Deyne, S., Navarro, D. J., Perfors, A., & Storms, G. (2016).
        Structure at every scale: A semantic network account of the
        similarities between unrelated concepts. *Journal of Experimental
        Psychology: General, 145*(9), 1228-1254.
        <http://dx.doi.org/10.1037/xge0000192>
    -   Jana, A., Haldar, S., & Goyal, P. (2022). Network embeddings
        from distributional thesauri for improving static word
        representations. *Expert Systems with Applications, 187*,
        e115868. <https://doi.org/10.1016/j.eswa.2021.115868>
    -   Johnson, D. R., & Hass, R. W. (2022). Semantic context search in
        creative idea generation. *The Journal of Creative Behavior,
        56*(3), 362-381. <https://doi.org/10.1002/jocb.534>
    -   Kumar, A. A., Balota, D. A., & Steyvers, M. (2020). Distant
        connectivity and multiple-step priming in large-scale semantic
        networks. *Journal of Experimental Psychology: Learning, Memory,
        and Cognition, 46*(12), 2261-2276. <https://doi.org/10.1037/xlm0000793>
    -   Kumar, A. A., Steyvers, M., & Balota, D. A. (2021). Semantic
        memory search and retrieval in a novel cooperative word game: a
        comparison of associative and distributional semantic models.
        *Cognitive Science, 45*(10), e13053. <https://doi.org/10.1111/cogs.13053>
    -   Maxwell, N. P., & Buchanan, E. M. (2020). Investigating the
        interaction of direct and indirect relation on memory judgments
        and retrieval. *Cognitive Processing, 21*(1), 41-53. <https://doi.org/10.1007/s10339-019-00935-w>
    -   Meersmans, K., Bruffaerts, R., Jamoulle, T., Liuzzi, A. G., De
        Deyne, S., Storms, G., Dupont, P., & Vandenberghe, R. (2020). Representation of associative and affective semantic similarity of abstract words
        in the lateral temporal perisylvian language regions.
        *NeuroImage, 217*, 116892. <https://doi.org/10.1016/j.neuroimage.2020.116892>
    -   Meersmans, K., Storms, G., De Deyne, S., Bruffaerts, R., Dupont,
        P., & Vandenberghe, R. (2022). Orienting to different dimensions
        of word meaning alters the representation of word meaning in
        early processing regions. *Cerebral Cortex, 32*(15), 3302-3317.
    -   Melvie, T., Taikh, A., Gagn\\'e, Christina L, & Spalding, T. L.
        (2022). Constituent processing in compound and pseudocompound
        words. *Canadian Journal of Experimental Psychology/Revue
        canadienne de psychologie expérimentale, 77*(2), 98–114. <https://doi.org/10.1037/cep0000287>
    -   Richie, R., & Bhatia, S. (2021). Similarity judgment within and
        across categories: a comprehensive model comparison. *Cognitive
        Science, 45*(8), e13030. <https://doi.org/10.1111/cogs.13030>
    -   Sarkar, S., Bhagwat, A., & Mukherjee, A. (2022). A
        core-periphery structure-based network embedding approach.
        *Social Network Analysis and Mining, 12*, 32. <https://doi.org/10.1007/s13278-021-00749-9>
    -   Valba, O., & Gorsky, A. (2022). K-clique percolation in free
        association networks and the possible mechanism behind the 7±2 law. *Scientific Reports, 12*, 5540. <https://doi.org/10.1038/s41598-022-09499-w>
    -   Valba, O., Gorsky, A., Nechaev, S., & Tamm, M. (2021). Analysis
        of english free association network reveals mechanisms of
        efficient solution of remote association tests. *PLOS ONE, 16*(4),
        e248986. <https://doi.org/10.1371/journal.pone.0248986>
    -   Vankrunkelsven, H., Vankelecom, L., Storms, G., De Deyne, S., &
        Voorspoels, W. (2021). Guessing Words. In G. Kristiansen, K. Franco, S. De Pascale, L. Rosseel, & W. Zhang (Eds.), *Cognitive Sociolinguistics Revisited* (pp. 572–583). : De Gruyter Mouton.
    -   Verheyen, S., De Deyne, S., Linsen, S., & Storms, G. (2020).
        Lexicosemantic, affective, and distributional norms for 1,000
        dutch adjectives. *Behavior Research Methods, 52*(3), 1108–1121. <https://doi.org/10.3758/s13428-019-01303-4>
    -   Wong, T. Y., Fang, Z., Yu, Y. T., Cheung, C., Hui, C. L., Elvevåg, B., ... & Chen, E. Y.(2022).
        Discovering the structure and organization of a free cantonese emotion-label
        word association graph to understand mental lexicons of
        emotions. *Scientific Reports, 12*, 19581. <https://doi.org/10.1038/s41598-022-23995-z>
    -   Wulff, D. U., De Deyne, S., Aeschbach, S., & Mata, R. (2022).
        Using network science to understand the aging lexicon: linking
        individuals' experience, semantic networks, and cognitive
        performance. *Topics in Cognitive Science, 14*(1), 93-110. <https://doi.org/10.1111/tops.12586>
    -   Wulff, D. U., & Mata, R. (2022). On the semantic representation
        of risk. *Science Advances, 8*(27), eabm1883. <https://doi.org/10.1126/sciadv.abm1883>
    -   Yang, Y., Li, L., de Deyne, S., Li, B., Wang, J., & Cai, Q. (2024). 
        Unraveling lexical semantics in the brain: Comparing internal, external, and hybrid language models. *Human Brain Mapping, 45*(1), e26546. <https://doi.org/10.1002/hbm.26546>
-   会议或预印等
    -   Ashok Kumar, A., Garg, K., & Hawkins, R. (2021). Contextual
        flexibility guides communication in a cooperative language game.
        In *Proceedings of the 43rd Annual Meeting of the Cognitive Science Society*. <https://escholarship.org/uc/item/92m138t3>
    -   Berger, U., Stanovsky, G., Abend, O., & Frermann, L. (2022). A
        computational acquisition model for multimodal word
        categorization. *arXiv*. <https://arxiv.org/abs/2205.05974>
    -   Branco, A., Rodrigues, J., Salawa, M., Branco, R., & Saedi, C. (2020). Comparative probing of lexical
        semantics theories for cognitive plausibility and technological
        usefulness. *arXiv*. <http://arxiv.org/abs/2011.07997>
    -   Du, Y., Wu, Y., & Lan, M. (2019). Exploring human gender
        stereotypes with word association test. In *Proceedings of the 2019 Conference on Empirical Methods in Natural Language Processing and the 9th International Joint Conference on Natural Language Processing (EMNLP-IJCNLP)* (pp. 6133-6143).
    -   Han, Z., & Truex, R. (2020). Measuring political attitudes with word association.
        (SSRN Scholarly Paper 3701860). <https://doi.org/10.2139/ssrn.3701860>
    -   Kovacs, C. J., Wilson, J. M., & Kumar, A. A. (2022). Fast and
        frugal memory search for communication. In *Proceedings of the Annual Meeting of the 44th Cognitive Science Society*. <https://escholarship.org/uc/item/3301p4cj>
    -   Liu, C., Cohn, T., De Deyne, S., & Frermann, L. (2022). Wax: A
        new dataset for word association explanations. In *Proceedings of the 2nd Conference of the Asia-Pacific Chapter of the Association for Computational Linguistics and the 12th International Joint Conference on Natural Language Processing (Volume 1: Long Papers)* (pp. 106-120).
    -   Liu, C., Cohn, T., & Frermann, L. (2021). Commonsense knowledge in word associations and ConceptNet.
        *arXiv*. <https://doi.org/10.48550/arXiv.2109.09309>
    -   Nedergaard, J., Smith, K., & Smith, K. (2020).
        Are you thinking what I'm thinking? Perspective-taking in a language game. In S. Denison, M. Mack, Y. Xu, & B. C. Armstrong (Eds.), In *Developing a Mind: Learning in Humans, Animals, and Machines: Proceedings for the 42nd Annual Meeting of the Cognitive Science Society* (pp. 1001-1007). Cognitive Science Society. <https://cognitivesciencesociety.org/wp-content/uploads/2020/07/cogsci20_proceedings_final.pdf>
    -   Nighojkar, A., Khlyzova, A., & Licato, J. (2022). Cognitive
        modeling of semantic fluency using transformers. *arXiv*. <http://arxiv.org/abs/2208.09719>
    -   Petridis, S., Shin, H. V., & Chilton, L. B (2021).
        Symbolfinder: Brainstorming diverse symbols using local semantic
        networks. In *The 34th Annual ACM Symposium on User Interface Software and Technology* (pp. 385-399). <https://doi.org/10.1145/3472749.3474757>
    -   Rodrigues, J., Branco, R., & Branco, A. (2022).
        Transfer learning of lexical semantic families for argumentative
        discourse units identification. *arXiv*. <https://doi.org/10.48550/arXiv.2209.02495>
    -   Rotaru, A. S. (2020). Computational explorations of semantic
        cognition [Doctoral dissertation, University College London]. <https://discovery.ucl.ac.uk/id/eprint/10106344/>
    -   Salawa, M. (2019). Word embeddings from lexical ontologies:
        A comparative study [Master's thesis]. <http://apohllo.pl/text/mgr/salawa-embeddingi.pdf>
    -   Sarkar, S., Bhagwat, A., & Mukherjee, A. (2018). Core2vec: A
        core-preserving feature learning framework for networks. In *2018 IEEE/ACM International Conference on Advances in Social Networks Analysis and Mining (ASONAM)* (pp. 487–490). <https://doi.org/10.1109/ASONAM.2018.8508693>
    -   Siow, S., & Plunkett, K. (2021). Exploring the variable effects
        of frequency and semantic diversity as predictors for a word's
        ease of acquisition in different word classes. In *Proceedings of the 43rd Annual Meeting of the Cognitive Science Society*. <https://escholarship.org/uc/item/83t6n1rq>
    -   Thawani, A., Srivastava, B., & Singh, A. (2019).SWOW-8500: word
        association task for intrinsic evaluation of word embeddings. In A. Rogers, A. Drozd, A. Rumshisky, & Y. Goldberg (Eds.), In *Proceedings of the 3rd Workshop on Evaluating Vector Space Representations for NLP* (pp. 43–51). Association for Computational Linguistics. <https://doi.org/10.18653/v1/W19-2006>
    -   van Paridon, J., Liu, Q., & Lupyan, G. (2021). How do blind
        people know that blue is cold? distributional semantics encode
        color-adjective associations. In *Proceedings of the Annual Meeting of the 43rd Cognitive Science Society*. <https://escholarship.org/uc/item/6sq7h506>
    -   Wulff, D. U., Aeschbach, S., De Deyne, S., & Mata, R. (2022).
        Data from the MySWOW proof-of-concept study: linking individual
        semantic networks and cognitive performance. *Journal of Open
        Psychology Data, 10*(1), 1-8. <https://doi.org/10.5334/jopd.55>
    -   Yang, W., & Ma, X. (2022). Building knowledge graphs of
        experientially related concepts. In *Proceedings of the 4th Conference on Automated Knowledge Base Construction (AKBC 2022)*. <https://akbc.ws/2022/papers/13_building_knowledge_graphs_of_e>

# 脚注

<sup><a id="fn.1" href="#fnr.1">1</a></sup> De Deyne, S., Navarro, D.
J., & Storms, G. (2013). Better explanations of lexical and semantic
cognition using networks derived from continued rather than single-word
associations. *Behavior Research Methods, 45*(2), 480-498.
<http://dx.doi.org/10.3758/s13428-012-0260-7>

<sup><a id="fn.2" href="#fnr.2">2</a></sup> Nelson, D. L., McEvoy, C.
L., & Dennis, S. (2000). What is free association and what does it
measure? *Memory & Cognition, 28*(6), 887-899. <https://doi.org/10.3758/BF03209337>

<sup><a id="fn.3" href="#fnr.3">3</a></sup> Cai, Q., & Brysbaert, M. (2010). SUBTLEX-CH: Chinese word and character frequencies based on film subtitles. *PLOS ONE, 5*(6), e10729. <https://doi.org/10.1371/journal.pone.0010729>

<sup><a id="fn.4" href="#fnr.4">4</a></sup> Liu, F., Yang, M., & Lin, D. (2010). *Chinese web 5-gram version 1* [dataset]. Linguistic Data Consortium. <https://doi.org/10.35111/647p-yt29>

<sup><a id="fn.5" href="#fnr.5">5</a></sup> De Deyne, S., Cabana, Á., Li, B., Cai, Q., & McKague, M. (2020). A cross-linguistic study into the contribution of affective connotation in the lexico-semantic representation of concrete and abstract concepts. In *Proceedings of the 42nd Annual Meeting of the Cognitive Science Society: Developing a Mind: Learning in Humans, Animals, and Machines* (pp. 2776–2782). Cognitive Science Society.
