# prtimes_intern

## スコア

### 初期

{"pass":true,"score":1133,"success":988,"fail":0,"messages":[]}
![alt text](image.png)

### 変更後

#### 変更理由

- SQL により CPU が圧迫されている
  ![alt text](image-3.png)

  - 一つのクエリでレスポンス時間の 70%を占めている
    ![alt text](image-4.png)
  - そのクエリでは、97k 行の確認をして、1.4 行の結果を返している
  - → 検査する数を減らせるのではないか

  - 原因の SQL を探る
    ![alt text](image-5.png)
  - 検索効率を上げる index が NULL なため、index を追加することで検索効率が上がる可能性がある
    - 変更前の comment table
      ![alt text](image-6.png)
    - index 追加後の comment table
      ![alt text](image-7.png)
    - post_id_idx を追加した
    - comment テーブル変更後の検索に必要な行数
      ![alt text](image-8.png)
    - 1 行に減っている
  - ここまでの変更でのスコアの変化
    ![alt text](image-9.png)
    `{"pass":true,"score":7881,"success":7030,"fail":0,"messages":[]}`

- app の負荷が SQL を超えた
  ![alt text](image-10.png)

### 不明点

- コードを何も変えていないのに、出力されるスコアが変化した理由
- ![alt text](image-1.png)

## 参考文献

- **解説記事を参考にした理由**
  - スコアを改善するには、どのような観点からの改善が必要なのかわからなかったから
- **参考記事を読んでわかったこと**
  - 今回の ISCON のインターン用ではチューニングを行ってスコアを上げる
  - チューニングの目的は、大量のアクセス等があった際システムのパフォーマンスが下がるのを防ぐため
  - チューニングの際、最初に行うのは、パフォーマンス低下の原因箇所を探す
- **参考記事**
  - [インターン生向けの ISUCON CM](https://qiita.com/catatsuy/items/2d83783d80157daf4b44)
  - [パフォーマンスチューニングの目的と流れを書いてみた](https://qiita.com/tbtakhk/items/ecf1bc502333d2bdab52)
- [社内で ISUCON 問題(private-isu)に触れてみた](https://note.com/pharmax/n/nf9a163c09554#11620be8-b693-465f-a0c4-157ef42ed8c2)
