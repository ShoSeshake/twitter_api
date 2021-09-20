<template>
  <v-app-bar dense color="blue accent-2" dark>

    <v-toolbar-title>Twitter Magagement</v-toolbar-title>

    <v-spacer></v-spacer>
    <template>
      <a href="/omniauth/twitter">Twitter</a>
    <router-link to="/">
      <v-btn icon>
        <v-icon>mdi-account-group</v-icon>
      </v-btn>
    </router-link>
    <router-link to="/tweets">
      <v-btn icon>
        <v-icon>mdi-comment-outline</v-icon>
      </v-btn>
    </router-link>
      <v-btn icon @click="reload">
        <v-icon>mdi-reload</v-icon>
      </v-btn>
    </template>
  </v-app-bar>
</template>

<script>
import axios from "axios";
import "vue-awesome/icons";

export default {
  methods: {
    reload() {
      this.$store.commit("setAjaxLoader", true);
      axios
        .get("/api/v1/users/refresh")
        .then((response) => {
          console.log(response);
          this.$router.go({
            path: this.$router.currentRoute.path,
            force: true,
          });
          this.$store.commit("setAjaxLoader", false);
        })
        .catch((error) => {
          console.log(error);
          this.$store.commit("setAjaxLoader", false);
        });
    },
  },
};
</script>

<style lang="scss" scoped>
  a {
    color:white;
    text-decoration: none;
  }
</style>