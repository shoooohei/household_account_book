# README

[![ruby version](https://img.shields.io/badge/Ruby-v2.5.1-red.svg)](https://www.ruby-lang.org/ja/)
[![rails version](https://img.shields.io/badge/Rails-v5.2.2.1-critical.svg)](http://rubyonrails.org/)
[![rails version](https://img.shields.io/badge/PostgreSQL-v10.6-blue.svg)](https://www.postgresql.org/)

## アプリ名: PairMoney
アプリURL: https://pairmoney.herokuapp.com/

## アプリ概要
夫婦またはカップル専用の家計簿webアプリケーション。  
簡単な出費の入力で、複雑な二人の出費を管理できる。  

## コンセプト
夫婦やカップルでも財布を分けて管理したい人をターゲットとしている。  
毎日の食費や日用品などの家族のための出費を記録して、１ヶ月単位で精算金額を計算できる。  

## 使用技術
- フロントエンド
  - Bootstrap 3.3.7
  - jQuery 3.2.1
  - AdminLTE 2.4.5
  - React 16.8.6 (電卓機能のみ)
  - React Redux 7.0.3 (電卓機能のみ)
- サーバーサイド
  - Ruby 2.5.1
  - Ruby on Rails 5.2.2.1
- データベース
  - PostgreSQL 10.6
- インフラ
  Heroku

## 実装機能
- カテゴリー登録機能
- 予算登録機能
- 出費登録機能
- 電卓機能
- 二人の貯金登録機能
- 収入登録機能
- 精算金額計算機能
- 手渡し料金登録機能
- 繰り返し出費登録機能
- パートナーレコード閲覧モード
- 管理画面機能

詳しくは[こちらのWiki](https://github.com/shoooohei/household_account_book/wiki)を参照

## ER Diagram
![er](https://github.com/shoooohei/household_account_book/blob/master/erd.png)

