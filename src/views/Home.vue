<template>
 <v-app >
    <app-menu/>
    <v-app-bar color="deep" dark > 
      <v-spacer></v-spacer> 
      <v-text-field @keyup.enter.native="search" v-model="filter" dense flat hide-details rounded solo-inverted ></v-text-field>  
      <v-btn icon  @click="search"><v-icon>mdi-magnify</v-icon> </v-btn>  
      <div v-if="!isMobile()"> 
        <v-container fluid>
          <v-row align="center">  
            <!-- <v-col >
              <v-btn style="margin:50px" @click="showFilter('filter')">
                <img src="../../public/filtro.svg" width="15px" style="margin:5px" />filtrar
              </v-btn>
            </v-col>  -->
            <v-col>
              <v-select style="width:150px;height:40px" v-model="orden" @change="applyFilter()"
                :items="['Descripción','Menor precio', 'Mayor precio', 'Más vendido']" 
                label="Ordenar por" >
              </v-select>
            </v-col> 
          </v-row>
        </v-container>   
      </div>
      <v-spacer></v-spacer> 
    </v-app-bar>
     
    <v-app-bar color="deep" dark v-if="isMobile()">  
      <v-container>
        <v-row>
          <v-col>
            <v-btn @click="showFilter('filter')" >
              <img src="../../public/filtro.svg" width="15px" style="margin:5px" />filtrar
            </v-btn>
          </v-col>
          <v-col>
            <!-- <v-btn @click="showFilter('order')">  
              <img src="../../public/ordenar.svg" width="15px" style="margin:5px"  />Ordenar
            </v-btn> -->
              <v-select style="width:150px;height:40px" v-model="orden" @change="applyFilter()"
                :items="['Descripción','Menor precio', 'Mayor precio', 'Más vendido']" 
                label="Ordenar por" >
              </v-select>
          </v-col>  
        </v-row>
      </v-container> 
    </v-app-bar> 

    <v-navigation-drawer v-model="sceemFiltro" absolute temporary width="300px"> 
        <v-list nav dense >
          <v-list-item-group>
              <!-- Inicio filtro -->
              <div v-if="typeScreem=='filter'">
                <v-list-item class="px-2">
                <v-list-item-title  @click.stop="sceemFiltro = !sceemFiltro">
                  <h1>Filtrar por</h1>
                </v-list-item-title> 
                <v-btn icon  @click.stop="sceemFiltro = !sceemFiltro"> 
                  <v-icon>mdi-chevron-right</v-icon>
                </v-btn>
              </v-list-item>
                <v-list-item> 
                    <v-list-item>
                        <v-container class="px-0" fluid>
                          <v-switch @change="filterOnlystock()" v-model="onlystock" label="Solo producto con existencia." ></v-switch>
                        </v-container> 
                    </v-list-item> 
                </v-list-item>   
                
                <v-list-item-title> 
                  <v-card flat color="transparent">
                    <v-list-item-title>Precio</v-list-item-title> 
                    <v-card-text>
                      <v-row>
                        <v-col class="px-4">
                          {{formatMXN(range[0])}}  -- {{formatMXN(range[1])}}
                          <v-range-slider v-model="range" @change="movementPriceFilter()"  :max="max" :min="min" hide-details class="align-center" >
                            <template v-slot:prepend>
                              <v-text-field  style="display:none;" :value="range[0]"  type="number" @change="$set(range, 0, $event)"></v-text-field>
                            </template>
                            <template v-slot:append style="">
                              <v-text-field  style="display:none;" :value="range[1]"  type="number" @change="$set(range, 1, $event)"></v-text-field>
                            </template>
                          </v-range-slider>
                        </v-col>
                      </v-row>
                    </v-card-text>
                  </v-card>  
                </v-list-item-title>

                <!-- <v-list-item>  -->
                <v-list-item-title>
                <v-card flat color="transparent">
                      <v-checkbox @change="applyFilter()" v-model="isfilterAndalucia"  label="Aromas de Andalucía"></v-checkbox>
                      <v-checkbox @change="applyFilter()" v-model="isfilterLD" label="Air Natur Home"></v-checkbox>
                </v-card> 
                </v-list-item-title>
              </div>
              <!-- Fin filtro -->
              <v-list-item-title>
                <div v-if="typeScreem=='order'">
                  <v-list-item class="px-2">
                    <v-list-item-title  @click.stop="sceemFiltro = !sceemFiltro">
                      <h1>Ordenar por</h1>
                    </v-list-item-title> 
                    <v-btn icon  @click.stop="sceemFiltro = !sceemFiltro"> 
                      <v-icon>mdi-chevron-right</v-icon>
                    </v-btn>
                  </v-list-item>  
                </div>
              </v-list-item-title>
          
          </v-list-item-group> 
        </v-list>
    </v-navigation-drawer>  
    <div style="min-heigth:40px;">
      <app-slider v-if="verfiltro == false && page == 1" /> 
    </div>
    <!-- <v-main style="wid" class="grey lighten-2">
      <v-container>
        <v-row>
          <v-col cols="12" sm="3" >
            <v-sheet rounded="lg" min-height="268" > 
          <v-col v-for="producto in productosOferta" :key="producto.value">  
            <v-alert dismissible color="cyan" border="left"  elevation="2" colored-border>
                 <v-card class="mx-auto my-12" width="260" height="500" @click=seeProduct(producto.value) >
                  <center>   
                    <v-img :src="`https://refividrio.com.mx/imgdis/${producto.value}.jpg`" :lazy-src="`../../public/noImg.png`"
                            aspect-ratio="1" class="grey lighten-2" width="220" height="170"> 
                      <template v-slot:placeholder>
                        <v-row class="fill-height ma-0" align="center" justify="center">
                          <v-progress-circular indeterminate color="grey lighten-5" ></v-progress-circular>
                        </v-row>
                      </template> 
                    </v-img>
                  </center>
                  <v-card-text>
                    <div class="my-4 subtitle-3">{{producto.name.substring(0,83)}}</div>
                    <div class="my-4 subtitle-2">{{producto.value}}</div>
                  </v-card-text> 
                  <v-divider class="mx-4">Costos</v-divider>
                  <v-card-title >
                    {{ formatMXN(producto.l0) }}
                  </v-card-title> 
                  <v-card-text>  
                    <div class="my-4 subtitle-1">
                      Cantidad Disponible: {{ producto.mex_quantytotal }}
                    </div> 
                  </v-card-text> 
                </v-card> 
            </v-alert>
          </v-col>


              
            </v-sheet>
          </v-col>

          <v-col cols="12" sm="8" >
            <v-sheet min-height="70vh" rounded="lg" > 
              hjjhjh
            </v-sheet>
          </v-col> -->

          <!-- <v-col cols="12" sm="2" >
            <v-sheet rounded="lg" min-height="268"  >
              lklk
            </v-sheet>
          </v-col> -->
        <!-- </v-row>
      </v-container>
    </v-main> -->
 
   <!-- <v-row> 
          <v-col v-for="producto in productosOferta" :key="producto.value">  
            <v-alert style="height:116px;" dismissible color="cyan" border="left"  elevation="2" colored-border>
                <v-col > 
                  <v-row>
                    <v-col cols="12" sm="3"> 
                      <v-img width="70px" :src="`https://refividrio.com.mx/imgdis/${producto.value}.jpg`" 
                      :lazy-src="`../../public/noImg.png`"
                        aspect-ratio="1" class="grey lighten-2" > 
                        <template v-slot:placeholder>
                          <v-row class="fill-height ma-0" align="center" justify="center">
                            <v-progress-circular indeterminate color="grey lighten-5" ></v-progress-circular>
                          </v-row>
                        </template> 
                      </v-img>
                    </v-col>
                    <v-col cols="12" sm="6">
                      <div style="font-size: 1em;color :#00A6FF">  
                        <v-icon style=" color: green;">mdi-shopping</v-icon>
                        {{ producto.name }}
                      </div> 
                    </v-col> 
                    <v-col cols="12" sm="2">
                        <v-btn color="primary" @click="menu('/shop/')" >
                          Agregar 
                        </v-btn>  
                    </v-col>
                  </v-row>  
                </v-col>
            </v-alert>
          </v-col>
        </v-row>   -->

<template class="grey lighten-2"  >
  <v-row class="grey lighten-2" > 
    <v-col cols="12" sm="1"></v-col>

    <v-col cols="12" sm="2" v-if="isMobile()">
          <v-alert dismissible>
            <v-alert dense type="info">
              Para dar una mejor presentación a sus productos adquiera nuestras <strong>NUEVAS BOLSAS</strong>
            </v-alert>
          <v-col  v-for="producto in productosOferta" :key="producto.value">  
            <center>
            <v-alert width="90%" color="cyan" border="left"  elevation="1" colored-border> 
                  <div  @click="seeProduct(producto.value)">
                  <center>   
                    <v-img width="40%" :src="`https://refividrio.com.mx/imgdis/${producto.value}.jpg`" 
                          :lazy-src="`../../public/noImg.png`"
                            aspect-ratio="1" class="grey lighten-2"> 
                      <template v-slot:placeholder>
                        <v-row class="fill-height ma-0" align="center" justify="center">
                          <v-progress-circular indeterminate color="grey lighten-5" ></v-progress-circular>
                        </v-row>
                      </template> 
                    </v-img>
                  </center>
                  <v-card-text>
                    <div class="my-4 subtitle-3">{{producto.name.substring(0,83)}}</div> 
                  </v-card-text>  
                  </div>
            </v-alert>
            </center>
        </v-col>
          </v-alert> 
    </v-col>

    <v-col cols="12" sm="2">   
      <v-list nav dense v-if="!isMobile()"  class="my-5">
          <v-list-item-group> 
              <div>
                  <h1>Filtrar por</h1> 
              <v-container class="px-0" fluid>
                <v-switch @change="filterOnlystock()" v-model="onlystock" label="Solo producto con existencia." ></v-switch>
              </v-container>   
              <v-card flat color="transparent">
                <br>
                <div><strong>Precio</strong></div>
                <v-card-text>
                  <v-row>
                    <v-col class="px-4">
                      {{formatMXN(range[0])}}  -- {{formatMXN(range[1])}}
                      <v-range-slider v-model="range" @change="movementPriceFilter()"  :max="max" :min="min" hide-details class="align-center" >
                        <template v-slot:prepend>
                          <v-text-field  style="display:none;" :value="range[0]"  type="number" @change="$set(range, 0, $event)"></v-text-field>
                        </template>
                        <template v-slot:append style="">
                          <v-text-field  style="display:none;" :value="range[1]"  type="number" @change="$set(range, 1, $event)"></v-text-field>
                        </template>
                      </v-range-slider>
                    </v-col>
                  </v-row>
                </v-card-text>
              </v-card><br>   
              <v-card flat color="transparent">
                    <v-checkbox @change="applyFilter()" v-model="isfilterAndalucia"  label="Aromas de Andalucía"></v-checkbox>
                    <v-checkbox @change="applyFilter()" v-model="isfilterLD" label="Air Natur Home"></v-checkbox>
              </v-card>  
              </div> 
          </v-list-item-group> 
        </v-list>
    </v-col> 
    
    <v-col cols="12" sm="6" class="grey lighten-5">  
              <v-container class="grey lighten-5" >  
                  <p v-if="verfiltro == true && valorBuscado != ''" style="font-size: 2em;color :#909090">  
                  <strong>{{valorBuscado}}</strong> 
                  <v-btn text color="error" @click="deleteFilter">X</v-btn>
                  </p>{{productos.length}} Resultados
              </v-container> 
              <v-row class="mb-6" no-gutters >    
                <div class="text-center">
                  <v-dialog v-model="isLoad" persistent width="300">
                    <v-card color="primary" dark >
                      <v-card-text>
                        cargando
                        <v-progress-linear indeterminate color="white" class="mb-0"></v-progress-linear>
                      </v-card-text>
                    </v-card> 
                  </v-dialog>
                </div>  
                <v-col v-for="producto in productosPaginator" :key="producto.value"> 
                  <v-card class="mx-auto my-3" width="260" height="500" @click="seeProduct(producto.value)" >
                    <center>   
                      <v-img :src="`https://refividrio.com.mx/imgdis/${producto.value}.jpg`" :lazy-src="`../../public/noImg.png`"
                              aspect-ratio="1" class="grey lighten-2" width="220" height="170"> 
                        <template v-slot:placeholder>
                          <v-row class="fill-height ma-0" align="center" justify="center">
                            <v-progress-circular indeterminate color="grey lighten-5" ></v-progress-circular>
                          </v-row>
                        </template> 
                      </v-img>
                    </center>
                    <v-card-text>
                      <div class="my-4 subtitle-3">{{producto.name.substring(0,83)}}</div>
                      <div class="my-4 subtitle-2">{{producto.value}}</div>
                    </v-card-text> 
                    <v-divider class="mx-4">Costos</v-divider>
                    <v-card-title >
                      {{ formatMXN(producto.l0) }}
                    </v-card-title> 
                    <v-card-text>  
                      <div class="my-4 subtitle-1">
                        Cantidad Disponible: {{ producto.mex_quantytotal }}
                      </div> 
                    </v-card-text> 
                  </v-card> 
                </v-col> 
              </v-row>   
              <div class="text-center">
                <v-pagination 
                  v-on:input="paginator" 
                  v-model="page" 
                  :length="lengthPaginator"  
                  circle
                  :total-visible="7"
                  ></v-pagination>
              </div>  
              <br> 
          </v-col>
          <v-col cols="12" sm="2" v-if="!isMobile()">
                <v-alert dismissible class="my-5">
                  <v-alert dense type="info">
                    Para dar una mejor presentación a sus productos adquiera nuestras <strong>NUEVAS BOLSAS</strong>
                  </v-alert>
                <v-col  v-for="producto in productosOferta" :key="producto.value">  
                  <center>
                  <v-alert width="100%" color="cyan" border="left"  elevation="1" colored-border> 
                        <div  @click="seeProduct(producto.value)">
                        <center>   
                          <v-img width="70%" :src="`https://refividrio.com.mx/imgdis/${producto.value}.jpg`" 
                                :lazy-src="`../../public/noImg.png`"
                                  aspect-ratio="1" class="grey lighten-2"> 
                            <template v-slot:placeholder>
                              <v-row class="fill-height ma-0" align="center" justify="center">
                                <v-progress-circular indeterminate color="grey lighten-5" ></v-progress-circular>
                              </v-row>
                            </template> 
                          </v-img>
                        </center>
                        <v-card-text>
                          <div class="my-4 subtitle-3">{{producto.name.substring(0,83)}}</div> 
                        </v-card-text>  
                        </div>
                  </v-alert>
                  </center>
              </v-col>
               </v-alert> 
          </v-col>
      <v-col cols="12" sm="1"></v-col>
     </v-row>       
</template>

    <!-- <v-main class="grey lighten-2" style="width:100%" > 
      <v-container class="grey lighten-5" >
        <v-row> 
          <v-col>
            vfgbhjk 
          </v-col>
          <v-col> 
              
          </v-col>
       
        </v-row>  
    </v-container>      
    </v-main>  -->

  </v-app> 
</template>  
 
<script>
import AppSlider from '../components/Slider'; 
import config from '../json/config.json'
import axios from 'axios'; 
import AppMenu from '../components/Menu.vue';

export default {
  name: "Productos", 
  props: ['pagina'], 
  data() {
    return {
      productosOferta : [],
      ordenMenorP : false,
      ordenMayorP : false,
      ordenMasVendido : false, 
      orden : 'Descripción',
      isfilterAndalucia:true,
      isfilterLD:true,
      onlystock : false,
      page: 1,
      filter : "",

      min: 0,
      max: 5000,
      range: [0, 5000],
      maxProd : 0,
      minProd : 0,
      // isMobile : null,
      sceemFiltro : false,
      typeScreem:null,
      productos : [],
      productosPaginator : [],
      lengthPaginator:0,
      totalPage:9,
      isLogged : false,
      user : {},
      isLoad : false,
      valorBuscado : "",
      verfiltro : false,
      productosFiltrados : []
    }; 
  }, 
  components: { 
    'app-slider': AppSlider,
    'app-menu': AppMenu, 
  }, 
  async created() {  
    console.log(this.$route.query);
    try{
      if (parseInt(this.pagina) > 0) {
        this.page = parseInt(this.pagina);
      }else{
        this.page = 1;
      }
    }catch (ex){
      this.page = 1;
    }
    this.isLoad = true;  
    await this.validaLogin();
    await this.allProduct(); 
    this.productosOferta = [];
    for (let index = 0; index < this.productos.length; index++) {
      let element = this.productos[index];  
      if (element.value == 'P15UN0978' || element.value == 'P15UN0979') {
          this.productosOferta.push(element);
      } 
    } 
    this.getExtremos();
    if(this.recoverParams()){
      this.applyFilter();
    } 
    await this.paginator();
    console.log(this.andalucia);
    this.isLoad = false;  
    
  } 
  ,methods: {
    recoverParams(){ 
      if (this.$route.query.isValid != undefined) { 
        try {
          this.filter = this.$route.query.filter;
          this.onlystock = this.$route.query.onlystock=='true'?true:false; 
          if (this.$route.query.range != undefined) { 
            this.range = this.$route.query.range;
          } 
          this.isfilterAndalucia = this.$route.query.isfilterAndalucia=='true'?true:false;
          this.isfilterLD = this.$route.query.isfilterLD=='true'?true:false;
          this.ordenMenorP =  this.$route.query.ordenMenorP=='true'?true:false;
          this.ordenMayorP = this.$route.query.ordenMayorP=='true'?true:false;
          this.ordenMasVendido = this.$route.query.ordenMasVendido=='true'?true:false;
          this.orden = this.$route.query.orden; 
          return true;
        } catch (error) { 
          console.log(error);
          return false;
        }
      }else{
        return false;
      }
    },
    getExtremos(){
      for (let index = 0; index < this.productos.length; index++) {
        const element = this.productos[index]; 
        if (index == 0) {
            this.min = element.l0;
            this.max = element.l0; 
        }
        if (parseFloat(this.max) < parseFloat(element.l0)){
          this.max = parseInt(element.l0);
        }
        if (parseFloat(element.l0) < parseFloat(this.min))
        { 
          this.min = parseInt(element.l0);
        }
      }  
      this.range = [this.min, this.max]; 
    },
    async applyFilter(){
      this.ordenMenorP = false;
      this.ordenMayorP = false;
      this.ordenMasVendido = false; 
      switch (this.orden) {
        case 'Menor precio': 
          this.ordenMenorP = true; 
          break;
        case 'Mayor precio':  
          this.ordenMayorP = true; 
          break;
        case 'Más vendido':  
          this.ordenMasVendido = true;
          break;    
      }
      this.isLoad = true;   
      await this.allProduct();
      this.page = 1;
      await this.paginator();
      this.verfiltro = true;
      this.sceemFiltro = false;
      this.isLoad = false;   
    },
    movementPriceFilter(){
      this.applyFilter();
    },
    async filterOnlystock(){
      this.applyFilter();
    },
    showFilter(value){ 
      this.typeScreem = value;
      this.sceemFiltro = true;
    },
    isMobile(){
      if( navigator.userAgent.match(/Android/i)
        || navigator.userAgent.match(/webOS/i)
        || navigator.userAgent.match(/iPhone/i)
        || navigator.userAgent.match(/iPad/i)
        || navigator.userAgent.match(/iPod/i)
        || navigator.userAgent.match(/BlackBerry/i)
        || navigator.userAgent.match(/Windows Phone/i)){
          return true;
        }else{
          return false;
        }
    },
    async deleteFilter(){
      this.page = 1;
      this.isLoad = true;  
      this.filter = "";
      this.valorBuscado = "";
      this.verfiltro = false;
      await this.allProduct();
      await this.paginator();
      this.isLoad = false;  
    },
    async search(){   
      this.isLoad = true;  
      this.valorBuscado = this.filter.toUpperCase();
      await this.allProduct();
      this.page = 1;
      await this.paginator();
      this.verfiltro = true;
      this.isLoad = false;  
    },
    async validaLogin(){
         this.user = await axios.get(config.apiAdempiere + "/user/userByToken", 
        {'headers': { 'token': this.$cookie.get('token') }})
        .then(res=>{return res.data;})
        .catch(err=>{return err;});    
        if (this.user.status == "success") {
          this.user = this.user.user; 
          this.isLogged = true;
        }else if(this.user.status == "unauthorized"){ 
          this.isLogged = false;
        }  
    }
    ,async allProduct(){ 
      this.productos = [];
      this.productosPaginator = [];
      let uri = config.apiAdempiere + "/productos/all";
      this.productos = await axios.get(uri
      ,{
        headers: { 'token': this.$cookie.get('token') },
        params: {
            filter: this.filter
            ,onliStock : this.onlystock
            ,range : this.range
            ,andalucia : this.isfilterAndalucia 
            ,ld : this.isfilterLD 
            ,ordenMenorP : this.ordenMenorP
            ,ordenMayorP : this.ordenMayorP
            ,ordenMasVendido : this.ordenMasVendido 
        }
      }
      ).then(function (response) { 
        if (response.data.status == "success") {
          return response.data.data;
        } else {
          console.log(response.data.data);
          return [];
        }
      }).catch(function (response){ 
        console.log(response);
        return [];
      }); 
      this.lengthPaginator = Math.ceil(this.productos.length/this.totalPage); 
    } 
    ,async paginator(){   
      this.isLoad = true; 
      this.productosPaginator = [];
      let fin = ((this.page * (this.totalPage )) -1) > (this.productos.length -1) ? (this.productos.length -1):((this.page * (this.totalPage )) -1);  
    
      for (let index = ( ( (this.page -1) * this.totalPage)); index <= fin; index++) {
        let element = this.productos[index];   
        // let img =  await axios.get(config.apiAdempiere + "/productos/imgByValue"
        //           ,{headers: { 'token': this.$cookie.get('token') },params: {filter: element.value}})
        // .then(function (response) { 
        //   if (response.data.status == "success") {
        //     return response.data.data[0].img;
        //   } else { 
        //      return false;
        //   }
        // }).catch(function (response){ 
        //   console.log(response);
        //   return false;
        // });  
        // if (img != false) {
        //   element.img = 'data:image/jpeg;base64,' + btoa(
        //     new Uint8Array(img.data)
        //     .reduce((data, byte) => data + String.fromCharCode(byte), '')
        //   );
        // }else{
        //   element.img = "../../noImg.png";
        // } 
        // element.img ="https://http2.mslstatic.com/D_NQ_NP_752ssss603-MLM32631339298_102019-O.webp" ;
         

        this.productosPaginator.push(element);
        if (index == fin) {
          this.isLoad = false;
          window.scrollTo(0,0);
        }
      } 
      window.scrollTo(0,0);
    },formatMXN(value) {
      var formatter = new Intl.NumberFormat('en-ES', {style: 'currency', currency: 'USD',});
      return formatter.format(value);
    },seeProduct(value){  
      // this.$router.push({
      //   path:`/shop/Product/${value}/home/${this.page}`
      //   ,query:{
      //     filter: this.filter
      //     ,onlystock : this.onlystock
      //     ,range : this.range
      //     ,isfilterAndalucia : this.isfilterAndalucia 
      //     ,isfilterLD : this.isfilterLD 
      //     ,ordenMenorP : this.ordenMenorP
      //     ,ordenMayorP : this.ordenMayorP
      //     ,ordenMasVendido : this.ordenMasVendido 
      //     ,orden : this.orden
      // }});
      this.$router.push(`/shop/Product/${value}/home/${this.page}`);
    } 
  },
  
}
</script>
