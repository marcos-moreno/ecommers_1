<!-- <template>
  <v-app>
    <v-app-bar
      app
      color="primary"
      dark
    >
      <div class="d-flex align-center">
        <v-img
          alt="Vuetify Logo"
          class="shrink mr-2"
          contain
          src="https://cdn.vuetifyjs.com/images/logos/vuetify-logo-dark.png"
          transition="scale-transition"
          width="40"
        />

        <v-img
          alt="Vuetify Name"
          class="shrink mt-1 hidden-sm-and-down"
          contain
          min-width="100"
          src="https://cdn.vuetifyjs.com/images/logos/vuetify-name-dark.png"
          width="100"
        />
      </div>

      <v-spacer></v-spacer>

      <v-btn
        href="https://github.com/vuetifyjs/vuetify/releases/latest"
        target="_blank"
        text
      >
        <span class="mr-2">Latest Release</span>
        <v-icon>mdi-open-in-new</v-icon>
      </v-btn>
    </v-app-bar>

    <v-main>
      <HelloWorld/>
    </v-main>
  </v-app>
</template>
-->
<script>
// import HelloWorld from './components/HelloWorld';

// export default {
//   name: 'App',

//   components: {
//     HelloWorld,
//   },

//   data: () => ({
//     //
//   }),
// };
</script>



<template>
  <v-app id="inspire">
 
    <app-menu/>

    <app-slider/>


    <v-main class="grey lighten-2">
      <v-container>
        <v-row>
            <!-- <products-index/> -->
        </v-row>
      </v-container>
    </v-main>

    <app-footer />

  </v-app>
</template>

<script>
//  import ProductsIndex from './components/ProductsIndex';
//  import AppSlider from './components/Slider'; 
//  import AppFooter from './components/Footer.vue';
//  import AppMenu from './components/Menu.vue';

//   export default {
//     components: {
//       // 'products-index': ProductsIndex,
//      'app-footer': AppFooter,
//       'app-menu':AppMenu,
//       'app-slider': AppSlider,
//     }
//   }
  // 'app-slider': AppSlider, 
   //   'app-footer': AppFooter,
</script>