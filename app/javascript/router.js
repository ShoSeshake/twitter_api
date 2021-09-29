import Vue from "vue";
import Router from "vue-router";
import store from "./store";
import RootPage from "./components/views/tops/RootPage";
import TweetsIndexPage from "./components/views/tweets/TweetsIndexPage";
import LoginPage from "./components/views/auths/LoginPage";
import OauthPage from "./components/views/auths/OauthPage";
import LikePage from "./components/views/likes/LikePage";

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
        if (store.getters.id) {
          next("/");
        } else {
          next();
        }
      },
    },
    {
      path: "/likes",
      component: LikePage,
    },
    {
      path: "/oauth",
      component: OauthPage,
    },
  ],
});
