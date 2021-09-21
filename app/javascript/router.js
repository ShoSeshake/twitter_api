import Vue from "vue";
import Router from "vue-router";
import store from "./store";
import RootPage from "./components/views/tops/RootPage";
import TweetsIndexPage from "./components/views/tweets/TweetsIndexPage";
import LoginPage from "./components/views/auths/LoginPage";
import OauthPage from "./components/views/auths/OauthPage";

Vue.use(Router);

export default new Router({
  mode: "history",
  routes: [
    {
      path: "/",
      component: RootPage,
    },
    {
      path: "/tweets",
      component: TweetsIndexPage,
    },
    {
      path: "/login",
      component: LoginPage,
      beforeEnter(to, from, next) {
        if (store.getters.idToken) {
          next("/");
        } else {
          next();
        }
      },
    },
    {
      path: "/oauth",
      component: OauthPage,
    },
  ],
});
