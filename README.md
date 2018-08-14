# バージョン
- ruby 2.3.0
- rails 5.1.4


# staging環境ログインアカウント
- URL  
https://stage-habfoc.herokuapp.com/

- user1 (user2のパートナー)  
user1@gmail.com  
000000  

- user2 (user1のパートナー)  
user2@gmail.com  
000000  

# アセッツプリコンバイル
`bundle exec rake assets:precompile RAILS_ENV=production`

# staging環境デプロイ方法
1. stage-habfocのgitリポジトリを追加  
`git remote add staging HEROKU-GIT-URL`  
2. stagingブランチにマージ
3. stagingブランチをpush  
`git push staging staging:master`
4. マイグレーション  
`heroku run rails db:migrate --remote staging`

# stylesheet適応方法
デフォルトなら`rails g`コマンドでassetsやhelperが自動生成されるが、  
`application.rb`で自動生成しないようにしてあるため、
scssファイルを足したいなら、`app/assets/stylesheets/`配下にファイルを作成し、  
`app/assets/stylesheets/application.scss`に`@import 'ファイル名';`を追記する。

# 背景
- カップルの財布を別にしたい
- 出費をしっかり管理したい
- 二人の出費をエクセルなどで管理するのは計算が少し複雑で、たまに例外もあったりすると、入力ミスや計算ミスが多くなる。



# 各機能
### 出費の入力(expense)
出費の入力のときに、自分の出費かパートナーとの出費かを入力するだけで、総支出額やカテゴリ別の出費の計算などを自動計算。


### 手渡し金額(pay)
自分がパートナーのために払った金額を考慮して、先月までの自分が本来払わなければいけない金額を計算する機能。
そして、自分がパートナーに手渡した金額を入力していけば、過去の全ての二人の出費のバランスを計算してくれる。
#### メリット
- 手渡す金額はいくらでもいいので、細かいお金は考えなくていい。
- パートナーのものを立て替えておいたときも、相手の支払い額100%で入力するだけで、その都度支払わなくて済む。
- 過去の出費を修正したり、過去の日付で新しく出費を入力しても、現在相手に手渡さなければいけない金額を計算してくれる。

### 繰り返し出費の計算(repeat_expnese)


### 欲しいものリスト(want)


### 通知機能(notification)
