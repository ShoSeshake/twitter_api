<template>
  <div class="page-wrapper" name="tweets-index-page">
    <v-card
      v-for="tweet in tweets"
      :key="tweet.id"
      class="mx-auto tweet-card"
      elevation="8"
    >
      <v-card-text v-text="tweet.tweet_text" style="white-space: pre-wrap">
      </v-card-text>
      <v-divider></v-divider>
      <v-card-actions color="blue accent-2">
        <v-container class="tweet-card__bottom">
          いいね数:{{ tweet.likes.length }}
        </v-container>
      </v-card-actions>
    </v-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      tweets: [],
    };
  },
  mounted() {
    this.$store
      .dispatch("getTweets")
      .then((res) => {
        this.$store.commit("setTweets", res.data);
        this.tweets = this.$store.getters.tweets;
        return;
      })
      .catch((err) => {
        console.log(err);
      });
  },
};
</script>

<style lang="scss" scoped>
.tweet-card {
  margin-top: 1rem;
  &__bottom {
    text-align: right;
}
}
.text-wrap {
  white-space: pre-wrap;
}
.page-wrapper {
  // background-color: white;
  padding: 32px 8px 32px;
  max-width: 600px;
  margin: 0 auto;
}
</style>