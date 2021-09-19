import Vue from "vue";
import Router from "vue-router";
// import store from "./store";
import RootPage from "./components/views/tops/RootPage";
import TweetsIndexPage from "./components/views/tweets/TweetsIndexPage";

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
    // {
    //   path: "/login",
    //   component: Login,
    //   beforeEnter(to, from, next) {
    //     if (store.getters.idToken) {
    //       next("/");
    //     } else {
    //       next();
    //     }
    //   },
    // },
    // {
    //   path: "/signup",
    //   component: SignUp,
    //   beforeEnter(to, from, next) {
    //     if (store.getters.idToken) {
    //       next("/");
    //     } else {
    //       next();
    //     }
    //   },
    // },
  ],
});
