
[<img src="https://smallworldofwords.org/img/logos/SWOW_Tag_Wide.png"/>](SWOW)

# Table of Contents

1.  [About Small World of Words project (SWOW) & SWOW-ZH](#orga7a1ee6)
2.  [Instructions to the repository](#org6423954)
    1.  [Obtaining the data](#org008856a)
    2.  [Raw data](#org1a6cd57)
    3.  [Preprocessing scripts](#orgc0ba651)
    4.  [Processing scripts](#orga56d790)
        1.  [Associative frequencies and graphs](#org8eea69f)
        2.  [Derived statistics](#orgdff87ab)
        3.  [Centralities and similarities](#org11b9387)
    4.  [Collection, preprocessing and processing of SWOW-GPT](#orga8bvv1)
    6.  [Applicability in other SWOW lexicons](#org511e306)
3.  [Data version history](#xCnQ)
4.  [Publications based on SWOW](#org124b364)

<a id="orga7a1ee6"></a>

# About [Small World of Words project (SWOW)](https://smallworldofwords.org/project/) & SWOW-ZH

The small world of words project is a large-scale scientific study that
aims to build a mental dictionary or lexicon in the major languages of
the world and make this information widely available
<sup><a id="fnr.1" class="footref" href="#fn.1" role="doc-backlink">1</a></sup>.

In contrast to a thesaurus or dictionary, we use word associations to
learn about what words mean and which ones are central in the human
mind. This enables psychologists, linguists, neuro-scientists and others
to test new theories about how we represent and process language. This
knowledge could also be applied in a variety of ways, from learning
about the difference between cultures, to learning (or forgetting) new
words in a first or a second language.

SWOW-ZH is a daughter project of SWOW to map mental lexicon in Chinese,
as the suffix `ZH` stands for *Zhongwen* (中文, *Chinese*). It was
initiated to provide a comprehensive framework to measure the mental
lexicon with regard to the Chinese culture and people, and the bases for
comparative studies between Chinese and other languages.

The participant task we used is called *multiple response association*
<sup><a id="fnr.2" class="footref" href="#fn.2" role="doc-backlink">2</a></sup>.
The methodology is based on a continued word association task, in which
participants see a cue word and are asked to give three associated
responses to this cue word. As the number of participants increases, the
lexicon becomes comprehensive and efficient in representing mental
lexicon. Therefore, it focuses on the aspects of word meaning that are
shared between people without imposing restrictions on what aspects of
meaning should be considered.

Chinese is a demographically and culturally complex language, whose
dialects and writing systems are difficult to exhaust. In the SWOW-ZH
project, we primarily *focused on Mandarin Chinese* (普通话, Putonghua)
and simplified Chinese writing system, which are used in most regions of
the Chinese mainland. Additionally, the native dialect of the
participants was collected as a complementary information.
Alternatively, another SWOW daughter project focusing on Cantonese,
[SWOW-HK](https://smallworldofwords.org/hk), might be of your interest.

-   The study was conducted in Professor CAI Qing's lab at the School of
    Psychology and Cognitive Science, East China Normal University
    (华东师范大学心理与认知科学学院，蔡清教授团队), in collaboration
    with Dr. Simon de Deyne at Melbourne University, who founded the
    SWOW project when he was under the supervision by Professor Gert
    Storms at University of Leuven.

-   Please address questions and suggestions to:

    -   DING Ziyi \| 丁子益 \|
        [ziyi.ecnu\@gmail.com](mailto:ziyi.ecnu@gmail.com) \|
        [ZiyiDing7\@github](https://github.com/ZiyiDing7)
    -   LI Bing \| 李兵 \|
        [lbing314\@gmail.com](mailto:lbing314@gmail.com) \|
        [lib314a\@github](https://github.com/lib314a)

-   Affiliations:

    -   Shanghai Key Laboratory of Brain Functional Genomics (Ministry
        of Education), Affiliated Mental Health Center (ECNU), Institute
        of Brain and Education Innovation, School of Psychology and
        Cognitive Science, East China Normal University, Shanghai, China
    -   Shanghai Center for Brain Science and Brain-Inspired Technology,
        Shanghai, China

-   Thanks:

    -   This work was supported by the National Natural Science
        Foundation of China (grant numbers 31970987 to Qing Cai) and the
        Australian Research Council Early Career Grant (DE140101749 to
        Simon De Deyne)

-   License of the data:
    See https://smallworldofwords.org/en/project/

-   License of the code:
    <a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

-   Cite us: 
    -   `APA`: Li, B., Ding, Z., De Deyne, S., & Cai, Q. (2024). A large-scale database of Mandarin Chinese word associations from the Small World of Words Project. Behavior Research Methods, 57(1), 34. http://dx.doi.org/10.3758/s13428-024-02513-1
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

<a id="orgec4a5fe"></a>

# Instructions to the repository

*Prompt: Instead of exploring the repo in your browser, cloning it onto your local machine may be more convenient.*

In this repository you will find a basic analysis pipeline for the
Chinese SWOW project which allows you to import a preprocessing the data
as well as compute some basic statistics.

<a id="org008856a"></a>

## Obtaining the data

In addition to the scripts, you will need to retrieve the word
association data. Currently word association and participant data is
available for 10,192 cues. The data consists of over 2 million responses
collected between 2016 and 2023. They are currently submitted for
publication. Note that the final version is subject to change. If you
want to use these data for your own research, you can obtain them from
the Small World of Words research page
(<https://smallworldofwords.org/zh/project/research>).

To start the pipeline, `SWOW-ZH_raw.(csv|mat)` should be put into the
data folder.

While the majority of the data was collected on [the SWOW platform
(ZH)](https://smallworldofwords.org/zh), a subset was collected on
another China-based surveying platform [NAODAO
(脑岛)](https://www.naodao.com) using the same tasks with the same
inclusion standards. This presumably won't detriment the reliability of
the data.

If you find any of this useful, please consider sharing the word
association study (<https://smallworldofwords.org/zh/project>).

<a id="org1a6cd57"></a>

## Raw data

Since this is an ongoing project, data is regularly updated. Hence, all
datafiles refer to a release date in its filename.

1.  SequenceNumber: A system coding, ascending from 1 to the end.

2.  TrialsID: Unique identifiers for trials. Each trial is made up of
    one cue and three responses.

3.  ParticipantID: Unique identifiers for the participants.

4.  Created_at: Time and date when trials were finished.

5.  Age: Age reported by participants.

6.  NativeLanguage: Chinese dialects and Mandarin reported by
    participants.

    -   Tags in the NAODAO platform:
        -   PUTON: Putonghua or Mandarin, which is the standards of
            pronunciation populated officially (普通话);
        -   SOUTHE: Southeast dialects, which represents northern and
            southern Fujian dialects, covering most of Fujian, Chaoshan,
            Hainan and Taiwan
            (东南部方言：代表为包括闽北及闽南方言，覆盖福建大部及潮汕、海南及台湾);
        -   NORTH: Northern dialects representing the three northeastern
            provinces and the Inner Mongolian dialect, Hebei-Yulu,
            Jiaodong, Liaodong and the northern part of the Hanshui
            River Basin
            (北方方言：代表为东北三省及内蒙方言、冀豫鲁、胶东、辽东和汉水流域北部);
        -   SOUTH: Southern dialects representing Cantonese in Guangxi,
            Guangdong, Hainan, Hong Kong and Macau
            (南部方言：代表为包括广西、广东和海南的平话、白话，及香港和澳门的粤语);
        -   JIANG: Jianghuai dialects, which represents Jianghuai River
            Basin, Subei and Lunan
            (江淮方言：代表为江淮流域及苏北、鲁南);
        -   SHAN: Shan-Shaan dialects from Shaanxi and Shanxi
            (陕、晋方言：代表为陕西及山西各地);
        -   HAKKA: Hakka languages scattered all over China
            (客家话：代表为分布在各地的客家族语);
        -   SOUTHW: Southwestern dialects from most of Yunguichuan,
            Hubei, and Hunan (西南方言：代表为云贵川鄂湘大部);
        -   WU: Wu dialects from Jiangxi and eastern Anhui, most of
            Zhejiang and Shanghai
            (吴方言：代表为江西和安徽东部、浙江大部及上海);
        -   NORTHW: Northwestern dialects from Yinchuan, Lanzhou, and
            Xining (西北方言：代表为银川、兰州、西宁).
    -   Tags in the SWOW platform:
        -   PUTON: Which is the same as NAODAO;
        -   EASTW: Which is the same as WU on NAODAO;
        -   JIANG: Which is the same as NAODAO;
        -   SHAN: Which is the same as NAODAO;
        -   HAKKA: Which is the same as NAODAO.
        -   NORTH: Which combines NORTH and NORTHW in NAODAO;
        -   SOUTH: Which combines SOUTHE, SOUTHW, and SOUTH in NAODAO;

7.  Gender: Gender of the participants (Female / Male / X), including
    female, male and non-binary.

8.  Education: Level of education participants selected from: 1 = None,
    2 = Elementary school, 3 = High School, 4 = College or University
    Bachelor, 5 = College or University Master.

9.  City: City location when tested, might be an approximation.

10. Country: Country location when tested.

11. Section: Identifiers for the data resources and the snowball
    iterations: set1-10 = Ten sets collected in the SWOW platform,
    NAODAO = One set collected in the NAODAO platform
    (<https://smallworldofwords.org/zh/project/research>)).

12. Cue: Cue word.

13. R1Raw: Raw primary associative response.

14. R2Raw: Raw secondary associative response.

15. R3Raw: Raw tertiary associative response.

16. R1: Primary associative response.

17. R2: Secondary associative response.

18. R3: Tertiary associative response.

<a id="orgc0ba651"></a>

## Preprocessing scripts

To avoid potential errors when reading Chinese strings in MATLAB, we recommend
loading and saving all data in `mat` format. We also provide data in `csv`
format for users of other programming languages. Although the preprocessing
scripts were primarily written in MATLAB, for the convenience of non-MATLAB
users, we provided plain-text dictionaries in the `data/dictionaries` folder and
`R` scripts in the `scripts` folder.

The preprocessing scripts consist of `wordCleaning.(m|R)`,
`participantCleaning.(m|R)` and `dataBalancing.(m|R)` scripts.

`wordCleaning.(m|R)`: Problematic cue words and responses are marked or
modified according to the dictionaries. The dictionaries could be found
in the data/dictionaries folder and they were editable. The input of the
script `SWOW-ZH_raw.mat` should be put in the data folder.

### The dictionaries

1. `tradCues.(txt|mat)` and `tradCues.(txt|mat)`: Traditional Chinese cues and responses were transformed into simplified equivalents based on Open Chinese Convert library, `ropencc` package was access from (<https://github.com/Lchiffon/ropencc>).

2. `englishRes.(txt|mat)`: English responses were commonly used in Mandarin, their capitalization has been corrected.

3. `unsplitedRes.(txt|mat)`: Joined responses, whose participants typed two or more responses into a single response box with separators like punctuation or symbols (e.g., comma, space, plus sign, and pause sign), were separated successively to individual responses, and only the first three were processed.

4. `longRes.(txt|mat)`: Long responses (length is over six) were marked with #Long, except for meaningful long words that had appeared at least twice. A meaningless long response was defined as a character string that needs adding or deleting at least one character to become a phrase.

5. `symbolRes.(txt|mat)`: Non-Chinese characters, which contained non-Chinese characters (letters, symbols, numbers, and/or punctuations), were modified and kept if meaningful and appeared more than once. Other kinds of such responses were marked as #Symbol.

6. `erRes.(txt|mat)`: Retroflex final (erhua or erization), which is a pronunciation feature that modifies the final sound of certain syllables, usually in the form -er (儿), was deleted from the responses.

7. `SWOWZHwordlist.mat`: A Chinese word list merged from SUBTLEX-CH<sup><a id="fnr.3" class="footref" href="#fn.3" role="doc-backlink">3</a></sup> and Unigram subset of Chinese Web 5-gram Verson 1<sup><a id="fnr.4" class="footref" href="#fn.4" role="doc-backlink">4</a></sup>. Responses excluded in the word list were considered as non-word responses in the participants cleaning stage.

`participantCleaning.(m|R)`: Problematic participants are deleted.

`dataBalancing.(m|R)`: Remain 55 participants for each cue words. The output
of the script is written to data/SWOW-ZH_R55.mat. The participants were
selected to favor participants with less missing responses and Mandarin
speakers. The preprocessed data could be found in the Small World of
Words research page
(<https://smallworldofwords.org/zh/project/research>).

### *Notes* on processing traditional characters

The conversion from traditional to simplified words were applied using the OpenCC
library (see [Open Chinese Convert 開放中文轉換](https://github.com/BYVoid/OpenCC)).  `R` users will find an `OpenCC`
port for `R` called ([ropencc](https://github.com/Lchiffon/ropencc)) and test
its text conversion like the following example:
```r
CONVERTER <- ropencc::converter(ropencc::T2S)
CONVERTER["詞彙"]
[1] "词汇"
```

<a id="orga56d790"></a>

## Processing scripts

The processing scripts consist of `networkGeneration.m`,
`frequencyCalculating.m`, `centralityCalculating.m` and
`similarityCalculating.m` scripts in MATLAB. The equivalent scripts in R
were adapted from SWOW-EN: `createSWOWGraph.R`,
`createAssoStrengthTable.R`, `createResponseStats.R`, `createCueStats.R`
and `createNetworkStatistics.R`.

Additionally, `gradientValidation.m` valid sample size to achieve a fine prediction to relatedness judgment tasks<sup><a id="fnr.5" class="footref" href="#fn.5" role="doc-backlink">5</a></sup>.

<a id="org8eea69f"></a>

### Associative frequencies and graphs

-   `networkGeneration.m`: The preprocessed data is used to derive the
    associative frequencies (i.e., the conditional probability of a
    response given a cue) and saved in the output folder named as
    assocFrequency_R1 or \_R123, where the first column contains cue
    words, the second column contain responses, the third column
    contains associative frequencies between them. Use associative
    frequencies to extract the largest strongly connected component for
    graphs based on the first response (R1) or all responses (R123). The
    graphs are written to data/ SWOW-ZH_network.mat. And the adjacency
    matrices are written to output folder named as adjacencyMatrix_R1 or
    \_R123 and consist of directed weighted matrices, where each row
    labeled by N cue words and each column labeled by N responses. Then,
    the N×N matrices are filled by normalized associative strengths. In
    most cases, associative frequencies will need to be converted to
    associative strengths by dividing with the sum of all strengths for
    a particular cue. Vertices that are not part of the largest
    connected component are listed in a report in the output folder
    named as lostNodes_R1 or \_R123.
-   `createSWOWGraph.R` and `createAssoStrengthTable.R` had the same
    functions as `networkGeneration.m`.

<a id="orgdff87ab"></a>

### Derived statistics

-   `frequencyCalculating.m`: The script is used to describe the
    characteristics of responses, cue words and participants.

1.  Response statistics

> Currently the script calculates the number of cue words where a
> response is reported as their types, tokens and hapax legomena
> responses (responses that only occur once). The results can be found
> in the output folder named as resStats.

2.  Cue statistics

> Only words that are part of the strongly connected component are
> considered. Results are provided for the R1 graph and the graph with
> all responses (R123). The results can be found in the output folder
> named as cueStats_R1 or \_R123. The file includes the following:

-   Coverage: How many of the responses are retained in the graph after
    removing those words that aren't a cue or aren't part of the
    strongest largest component.

-   Unknown: The number of unknown responses

-   R1missing: The number of missing R1 responses

-   R2missing: The number of missing R2 responses

-   R3missing: The number of missing R3 responses

> A histogram of the response coverage for R1 and R123 graphs can be
> obtained from the frequencyCalculating.m script. Vocabulary growth
> curves can be obtained with `scripts/as-vocabulary-growth.R`

-   `createResponseStats.R` and `createCueStats.R` had the same
    functions as `frequencyCalculating.m`.

<a id="org11b9387"></a>

### Centralities and similarities

-   `centralityCalculating.m`: Based on the largest strongly connected
    component for graphs, the script calculates centrality-related
    indicators including: types and tokens, in-degree, out-degree,
    PageRank, clustering coefficient, centrality and betweenness. The
    scrip inserts some functions from the Brain Connectivity Toolbox
    (BCT) (<http://www.brain-connectivity-toolbox.net>). The output is
    written in the output folder named as centrality_R1 or \_R123.

-   `similarityCalculating.m`: Based on the largest strongly connected
    component for graphs, the script calculates four kinds similarity
    including: cosine similarity only (AssocStrength), positive
    pointwise mutual information (PPMI), random walk (RW) and word
    embedding after random walk (RW-embedding). The script is adapted
    from SWOW-EN and SWOW-RP. The output is written in the output folder
    named as similarity_R1 or \_R123.

-   `createNetworkStatistics.R` had the same functions as
    `centralityCalculating.m`.

<a id="org511e306"></a>

### Validation of sample size

`gradientValidation`: Based on the raw data after participant cleaning (`SWOW-ZH_partcleaning.m`), to finish the validation, behavior data from relatedness judgment tasks should be put into the data folder. The sample size is expanded from 20 to 80 participants per cue word for concrete words, and 20 to 120 participants per cue word for abstract words.

## Collection, preprocessing and processing of SWOW-GPT 
<a id="orga8bvv1"></a>

GPT-3.5-turbo was used through the OpenAI API to conduct the three-response free association task, which we refer to as *SWOW-GPT*. To ensure comparability with human-generated data, identical preprocessing and processing steps have been implemented. 

In the SWOW-GPT folder:
- The script `WS_gpt.html` contains instructions and parameters applied to GPT-3.5-turbo for generating associations;
- The preprocessing and processing scripts, in MATLAB, are organized to mirror the structure of the prep scripts for SWOW-ZH.

### SWOW-GPT raw data

There are four columns in `SWOW-GPT_raw.(mat|csv)`: Cue, R1Raw, R2Raw, and R3Raw, representing cue words sent to GPT-3.5-turbo, and three responses for each cue word answered by GPT-3.5-turbo.

### SWOW-GPT preprocessing scripts

The preprocessing scripts consist of `wordCleaning.m` and `dataBalancing.m` scripts.

`wordCleaning.m`: Problematic cue words and responses are marked or
modified according to the dictionaries. The dictionaries could be found
in the SWOW-GPT/data/dictionaries folder and they were editable. The input of the
script, SWOW-GPT_raw.mat, should be put in the SWOW-GPT/data folder.

`dataBalancing.m`: Embed associations from GPT-3.5-turbo into human SWOW-ZH, and then remain 55 participants for each cue words. The inputs of the script include `SWOW-ZH_partcleaning.mat` in the SWOW-GPT/data folder. The output
of the script is written to data/SWOW-GPT_R55.mat. The participants were
selected to favor trials with less missing responses.

### SWOW-GPT processing scripts

The processing scripts consist of `networkGeneration.m`,
`similarityCalculating.m` and `gradientValidation.m`.

## Applicability in other SWOW lexicons

Since other SWOWs are mainly processed by R scripts, a MATLAB scrip is
provided thus other SWOWs could be processed by MATLAB. The `SWOWs.m` is
used to count associative frequencies and generate graphs, and calculate
in-degrees of other SWOWs. The inputs of the script are preprocessed
data of other SWOWs put in the data/SWOWs folder. The outputs of the
script are the graphs written to data/SWOWs/SWOW-XX_network.mat. While
the XX could be substituted by EN (American English), NL (Dutch) and RP
(Rioplatense Spanish). The outputs could be loaded as inputs into
`centralityCalculating.m` and `similarityCalculating.m`

<a id="xCnQ"></a> \# Data version history <https://smallworldofwords.org/zh/project/research>

-   Current: 4 November 2024

<a id="org124b364"></a>

# Publications based on SWOW

Following is an exhaustive list of the publications based on or used
part of the lexicons:

-   Journal articles
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
-   Proceedings, pre-prints etc
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

# Footnotes

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
