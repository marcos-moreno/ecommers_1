<template>
  <v-carousel  v-model="indexSlider" hide-delimiters height="100%"> 
    <v-carousel-item v-for="(item,i) in imgs" :key="i"  >
        <v-img contain :src="item" height="100%" width="100%"></v-img>
    </v-carousel-item>
  </v-carousel> 
</template>

<script> 
  export default {
    data: () => ({
      indexSlider: 0,
      imgs: [
        '../flyers2108/1.jpeg', 
        '../flyers2108/2.jpeg', 
        '../flyers2108/3.jpeg', 
        // '../flyers2108/4.jpeg', 
        // '../flyers2108/5.jpeg', 
        // '../flyers2108/6.jpeg', 
        '../flyers2108/7.jpeg', 
        '../flyers2108/8.jpeg', 

        '../catalogoHome.jpg', 
        '../bannerbolsas2.jpeg', 
        '../andalucia.webp',
        '../ld.webp',
      ],
    }),
    methods:{
      changeSlider(){
        if (this.indexSlider == this.imgs.length-1) {
          this.indexSlider = 0; 
        }else{
          this.indexSlider ++;
        }  
      } 
    },
    created(){
      setInterval(this.changeSlider, 10000);
    }
  }
</script>