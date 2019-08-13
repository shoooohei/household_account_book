#!/bin/sh

##############################################################
# コンテナ起動スクリプト
#
#   webサーバとdbサーバのコンテナを起動します。
#
#   $ sh start_rails_container.sh
#
##############################################################

COMMAND_RESULT=`docker-compose ps -q`

if [ '' == "$COMMAND_RESULT" ] ; then

    # バックグラウンドで起動
    docker-compose up -d --build

    # node modulesをインストール
    docker-compose exec web yarn install

    # マイグレーション
    docker-compose exec web rails db:migrate

    # テストデータ投入
    docker-compose exec web rails db:seeds

    # テスト環境データベース作成
    docker-compose exec web rails db:create RAILS_ENV=test

    # テスト環境マイグレート
    docker-compose exec web rails db:migrate RAILS_ENV=test

    # テスト環境テストデータ投入
    docker-compose exec web rails db:seed_from_file SEED_FILENAME='seeds/00_category_masters_seeds.rb' RAILS_ENV=test

    # rails再起動
    docker-compose exec web rails restart

else

    # バックグラウンドで起動のみ
    docker-compose up -d --build

fi

