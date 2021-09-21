import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";
import auth from "./modules/auth";

// import axios from "../axios-auth";
// import router from "../router";
// import axiosRefresh from "../axios-refresh";

Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    auth,
  },
  state: {
    tweets: [],
    users: [],
    loading: false,
  },
  getters: {
    loading: (state) => state.loading,
    tweets: (state) => state.tweets,
    users: (state) => state.users,
  },
  mutations: {
    setTweets(state, tweets) {
      state.tweets = tweets;
    },
    setUsers(state, users) {
      state.users = users;
    },
    setAjaxLoader(state, loading_status) {
      state.loading = loading_status;
    },
  },
  actions: {
    getUsers() {
      return axios.get("/api/v1/users");
    },
    getTweets() {
      return axios.get("/api/v1/tweets");
    },
  },

});
