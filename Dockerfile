FROM ruby:2.6.3

# timezone
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ENV LANG C.UTF-8
ENV APP_ROOT /usr/src/household_account_book

RUN mkdir -p $APP_ROOT
WORKDIR $APP_ROOT

# yarnをインストールする前に必要な設定
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# 必要なライブラリ等をインストール
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      nodejs \
      yarn \
      vim \
      postgresql-client \
      graphviz

# キャッシュされているパッケージを削除
RUN apt-get clean
# キャッシュされているパッケージリストを削除
RUN rm -rf /var/lib/apt/lists/*

# Bundlerをインストール
RUN gem install bundler -v 1.17.3

# bundle install
COPY Gemfile $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
RUN bundle install

# npm packagesをインストール
COPY package.json $APP_ROOT
COPY yarn.lock $APP_ROOT
RUN yarn install --frozen-lockfile

# ソースコードを全てimageにコピー
COPY ./ $APP_ROOT

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# サーバー起動
#CMD ["rails", "server", "-b", "0.0.0.0"]