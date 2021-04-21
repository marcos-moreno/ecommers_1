<template>
  <v-carousel v-model="model" hide-delimiters height="100%"> 
    <v-carousel-item v-for="(item,i) in imgs" :key="i"  >
        <v-img contain :src="item" height="100%" width="100%"></v-img>
    </v-carousel-item>
  </v-carousel>
</template>

<script>
  export default {
    data: () => ({
      model: 0,
      imgs: [
        'https://http2.mlstatic.com/optimize/o:f_webp/resources/exhibitors/MLM-home-office-ideal/79f4c470-78b5-11eb-b135-e5c63f281232-home-slider_desktop.jpg', 
        'https://http2.mlstatic.com/optimize/o:f_webp/resources/exhibitors/MLM-impresion/9b3bbba0-78bc-11eb-883e-3dd1e5cce2fc-home-slider_desktop.jpg',
        'https://http2.mlstatic.com/optimize/o:f_webp/resources/deals/exhibitors_resources/mlm-home-desktop-slider-picture-9bbb61c1-4fd7-4088-af84-d76ce7b82a1d.jpg',
        'https://http2.mlstatic.com/optimize/o:f_webp/resources/deals/exhibitors_resources/mlm-home-desktop-slider-picture-0633f686-ec23-4c14-856b-066bd791b4ea.jpg',
      ],
    }),
  }
</script>