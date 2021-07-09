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
              <v-select style="width:150px;height:40px" v-model="orden" @change="applyFilter()"
                :items="['Descripción','Menor precio', 'Mayor precio', 'Más vendido']" 
                label="Ordenar por" >
              </v-select>
          </v-col>  
        </v-row>
      </v-container> 
    </v-app-bar> 

    <v-navigation-drawer v-model="sceemFiltro" absolute temporary width="300px" class="blue-grey lighten-5 height-app" app>   
        <v-list nav dense >
          <!-- Inicio filtro CELULAR-->
          <v-list-item-group>
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
  
               <v-list>
                    <v-list-group v-model="show_marca">
                      <template v-slot:activator>
                        <v-list-item-content>
                          <v-list-item-title >MARCA</v-list-item-title>
                        </v-list-item-content>
                      </template> 
                      <v-list-item>
                        <v-list-item-content>
                          <v-list-item-title >  
                            <v-checkbox class="my-8"
                            style="width:0.5px;height:0.5px;"
                                v-for="marca in atttibutes.marcas" :key="marca.value"
                                      @change="applyFilter()" v-model="marca.isview" :label="marca.marca"></v-checkbox>
    
                          </v-list-item-title>
                        </v-list-item-content>
                      </v-list-item>
                    </v-list-group>
                    <v-list-group v-model="show_intencidad">
                      <template v-slot:activator>
                        <v-list-item-content>
                          <v-list-item-title >INTENCIDAD</v-list-item-title>
                        </v-list-item-content>
                      </template> 
                      <v-list-item>
                        <v-list-item-content>
                          <v-list-item-title > 
                            <v-checkbox class="my-8"
                            style="width:0.5px;height:0.5px;"
                            v-for="intencidad in atttibutes.intencidades" :key="intencidad.m_class_intensity_id"
                              @change="applyFilter()" v-model="intencidad.isview" :label="intencidad.intencidad"></v-checkbox>
                          </v-list-item-title>
                        </v-list-item-content>
                      </v-list-item>
                    </v-list-group>
                  </v-list>
                  <v-divider class="my-5"></v-divider>
                  <div><strong >Clasificación</strong></div>
                  <v-list>
                    <v-list-group
                      v-for="categoria in atttibutes.categorias" :key="categoria.m_product_category_id" no-action>
                      <template v-slot:activator>
                        <v-list-item-content>
                          <v-list-item-title v-text="categoria.categoria"></v-list-item-title>
                        </v-list-item-content>
                      </template> 
                      <v-list-item v-for="sub_categoria in categoria.sub_categorias"
                                    :key="sub_categoria.m_product_classification_id">
                        <v-list-item-content>
                          <v-list-item-title v-text="sub_categoria.sub_categoria"></v-list-item-title>
                        </v-list-item-content>
                      </v-list-item>
                    </v-list-group>
                  </v-list>

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
        <br><br><br><br><br>
        <div class="my-10"></div>
    </v-navigation-drawer>  
    <div style="min-heigth:40px;">
      <app-slider v-if="verfiltro == false && page == 1" /> 
    </div> 
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
        <!-- Inicio filtro Escritorio-->
        <v-col cols="12" sm="" v-if="isLoad==false">  
          <v-list nav dense v-if="!isMobile()"  class="my-5">
              <h2>Filtrar por</h2> 
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
              </v-card>
              <br> 

              <v-list>
                <v-list-group  @click="!show_marca?show_marca=true:show_marca=false" :value="show_marca">
                  <template v-slot:activator>
                    <v-list-item-content>
                      <v-list-item-title>MARCA</v-list-item-title>
                    </v-list-item-content>
                  </template> 
                  <v-list-item>
                    <v-list-item-content>
                      <v-list-item-title >  
                        <v-checkbox class="my-8"
                        style="width:0.5px;height:0.5px;"
                          v-for="marca in atttibutes.marcas" :key="marca.value"
                                  @change="applyFilter()" v-model="marca.isview" :label="marca.marca"></v-checkbox>
                      </v-list-item-title>
                    </v-list-item-content>
                  </v-list-item>
                </v-list-group>
              </v-list>

              <v-list>
                <v-list-group @click="!show_intencidad?show_intencidad=true:show_intencidad=false" :value="show_intencidad">
                  <template v-slot:activator >
                    <v-list-item-content>
                      <v-list-item-title >INTENCIDAD</v-list-item-title>
                    </v-list-item-content>
                  </template> 
                  <v-list-item>
                    <v-list-item-content>
                      <v-list-item-title > 
                        <v-checkbox class="my-8"
                        style="width:0.5px;height:0.5px;"
                        v-for="intencidad in atttibutes.intencidades" :key="intencidad.m_class_intensity_id"
                          @change="applyFilter()" v-model="intencidad.isview" :label="intencidad.intencidad"></v-checkbox>
                      </v-list-item-title>
                    </v-list-item-content>
                  </v-list-item>
                </v-list-group>
              </v-list>


              <v-divider class="my-5"></v-divider>
              <div><strong >Clasificación</strong></div>

              <v-list>  
                <v-list-group 
                  v-for="categoria in atttibutes.categorias" 
                  :key="categoria.m_product_category_id"
                  v-model="categoria.is_active"
                  no-action 
                  sub-group  
                >
                  <template v-slot:activator>
                    <v-list-item-content
                      @click="add_category_filter(categoria)"  
                      v-bind:style= "[
                      comprobarExistenciaInArray(filtrosCategorias,categoria.m_product_category_id,'m_product_classification_id')
                      ? {'color':'green'} : {}]"
                    > 
                      <v-list-item-title v-text="categoria.categoria"></v-list-item-title>
                    </v-list-item-content>
                  </template>  
                  <v-list-item  @click="add_sub_category(sub_categoria,categoria)" 
                                v-for="sub_categoria in categoria.sub_categorias"
                                :key="sub_categoria.m_product_classification_id">
                    <v-list-item-content
                      v-bind:style= "[
                      comprobarExistenciaInArray(filtrosSubcategoria,sub_categoria.m_product_classification_id,'m_product_classification_id')
                      ? {'color':'#F78B09'} : {}]"
                    >
                      <v-list-item-title v-text="sub_categoria.sub_categoria"></v-list-item-title>
                    </v-list-item-content>
                  </v-list-item>
                </v-list-group>
              </v-list>  
          </v-list>  
        </v-col> 
        
        <v-col cols="12" sm="6" class="grey lighten-5">  
          <v-container class="grey lighten-5" > 
          
            <v-chip class="ma-2"  v-for="categoria in filtrosCategorias" :key="categoria.m_product_category_id" 
              close color="primary" outlined @click:close="delete_categoria(categoria)">
              {{categoria.categoria}}
            </v-chip>

            <v-chip class="ma-2" v-for="sub_categoria in filtrosSubcategoria" :key="sub_categoria.m_product_classification_id" 
              close color="orange" label outlined  @click:close="delete_sub_categoria(sub_categoria.m_product_classification_id)">
              {{sub_categoria.sub_categoria}}
            </v-chip>
            <br>
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
              <v-hover>
                <template v-slot:default="{ hover }">
                    <v-card style=" border-bottom: 2px solid red" :elevation="hover ? 24 : 2" class="mx-auto my-3"
                      width="260" height="500" @click="seeProduct(producto.value)">
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

                    

                      <v-container class="mx-auto" style="height:50%;"> 
                        <v-card-text>  
                          <div>{{producto.name}}</div>  
                          <div class="my-4 subtitle-2">{{producto.categoria}} :  {{producto.sub_categoria}} </div> 
                          <div class="my-4 subtitle-2">presentación: {{producto.presentacion}}</div> 
                          <div class="my-4 subtitle-2">Intencidad : {{producto.intencidad}}</div>
                        </v-card-text>  
                      </v-container >

                      <v-divider class="mx-4">Costos</v-divider>
                      <v-card-actions>
                          <v-chip class="ma-2"  color="pink" label text-color="white">
                            {{ formatMXN(producto.l0) }}
                          </v-chip> 
                          <v-chip  class="ma-2" color="pink" label text-color="white">
                            {{ producto.mex_quantytotal }}{{producto.mex_quantytotal==1?' Disponible':' Disponibles'}}
                          </v-chip> 
                      </v-card-actions> 
                    </v-card> 
                </template>
              </v-hover> 
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
      productosFiltrados : [],
      atttibutes : {marcas:[],categorias:[],intencidades:[],presentaciones:[]},
      filtrosCategorias : [],
      filtrosSubcategoria : [],

      show_intencidad : false,
      show_marca : false,
    }; 
  }, 
  components: { 
    'app-slider': AppSlider,
    'app-menu': AppMenu, 
  }, 
  async created() {
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
    await this.getattibutes();
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
    this.isLoad = false;  
  } 
  ,methods: {
    add_category_filter(categoria){ 
      if (categoria.sub_categorias.length == 0) {
        this.add_category(categoria,true);
      } 
    },
    delete_sub_categoria(m_product_classification_id){ 
      if (this.comprobarExistenciaInArray(this.filtrosSubcategoria,m_product_classification_id,'m_product_classification_id')){
        let filtros = [];
        for (let index = 0; index < this.filtrosSubcategoria.length; index++) { 
          if (this.filtrosSubcategoria[index].m_product_classification_id != m_product_classification_id) {
            filtros.push(this.filtrosSubcategoria[index]); 
          }
        }
        this.filtrosSubcategoria = filtros;
        this.applyFilter();
      }
    },
    delete_categoria(categoria){ 
      if (this.comprobarExistenciaInArray(this.filtrosCategorias,categoria.m_product_category_id,'m_product_category_id')){
        for (let index = 0; index < categoria.sub_categorias.length; index++) {
          this.delete_sub_categoria(categoria.sub_categorias[index].m_product_classification_id);
        }
        let filtros = []; 
        for (let index = 0; index < this.filtrosCategorias.length; index++) { 
          if (this.filtrosCategorias[index].m_product_category_id != categoria.m_product_category_id) {
            filtros.push(this.filtrosCategorias[index]); 
          }
        }  
        this.filtrosCategorias = filtros;
        this.applyFilter();
      } 
    },
    add_category(categoria,apllifilter){
      if (!this.comprobarExistenciaInArray(
        this.filtrosCategorias
        ,categoria.m_product_category_id
        ,'m_product_category_id')) {
        this.filtrosCategorias.push(categoria); 
        if (apllifilter) {
          this.applyFilter(); 
        }
      }
    },
    add_sub_category(sub_categoria,categoria){  
      this.add_category(categoria,false);
      if (!this.comprobarExistenciaInArray(
        this.filtrosSubcategoria
      ,sub_categoria.m_product_classification_id
      ,'m_product_classification_id')){
        this.filtrosSubcategoria.push(sub_categoria);
        this.applyFilter();
      }
    },
    comprobarExistenciaInArray(array,value,field){
      let respuesta = false;
      for (let index = 0; index < array.length; index++) {
        const element = array[index]; 
        if (element[field] == value) {
          respuesta = true;
        }
      } 
      return respuesta;
    },
    async getattibutes(){
      this.atttibutes.marcas = await this.requestattributes('marcas',0);
      this.atttibutes.categorias = await this.requestattributes('categoria',0);
      for (let index = 0; index < this.atttibutes.categorias.length; index++) {  
        let res = await this.requestattributes('sub_categoria' ,this.atttibutes.categorias[index].m_product_category_id)
        this.atttibutes.categorias[index].sub_categorias = res;
      }
      this.atttibutes.intencidades = await this.requestattributes('intencidad',0);
      this.atttibutes.presentaciones = await this.requestattributes('presentacion',0); 
    }, 
    async requestattributes(types,m_p_cat_id){
      let resource = [];
      resource = await axios.get(config.apiAdempiere + "/productos/getattributes", 
      {'headers': { 'token': this.$cookie.get('token') },params:{type:types,m_product_category_id:m_p_cat_id}})
      .then(res=>{return res.data;}) 
      .catch(err=>{return err;});    
      if (resource.status == "success") {
        resource = resource.data;
      }else{
        resource = [];
      }
      return resource;
    },
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
    ,agrupacion_isview(array,fieldconcat,isFilter){
      let cadenaRetorno = ""; 
      for (let i = 0; i < array.length; i++) { 
        const element = array[i];
        if (isFilter) {
          if (element.isview) {
            cadenaRetorno += element[fieldconcat] + ",";
          }
        }else{
          cadenaRetorno += element[fieldconcat] + ",";
        } 
      }
      cadenaRetorno += "#";
      cadenaRetorno = cadenaRetorno.replace(',#',''); 
      return cadenaRetorno;
    }
    ,async allProduct(){ 
      this.productos = [];
      this.productosPaginator = [];

      let empresasValidas = this.agrupacion_isview(this.atttibutes.marcas,'m_product_group_id',true);
      let intencidadesValidas = this.agrupacion_isview(this.atttibutes.intencidades,'m_class_intensity_id',true);
   
      let categorias_group_v = this.agrupacion_isview(this.filtrosCategorias,'m_product_category_id',false);
      let sub_categorias_group_v = this.agrupacion_isview(this.filtrosSubcategoria,'m_product_classification_id',false);

      let uri = config.apiAdempiere + "/productos/all";
      this.productos = await axios.get(uri
      ,{
        headers: { 'token': this.$cookie.get('token') },
        params: {
            filter: this.filter
            ,onliStock : this.onlystock
            ,range : this.range
            ,marcasfiltradas : empresasValidas
            ,ordenMenorP : this.ordenMenorP
            ,ordenMayorP : this.ordenMayorP
            ,ordenMasVendido : this.ordenMasVendido  
            ,intencidadesfiltradas : intencidadesValidas
            ,categorias_group : categorias_group_v
            ,sub_categorias_group : sub_categorias_group_v
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
        this.productosPaginator.push(element);
        if (index == fin) {
          this.isLoad = false;
          window.scrollTo(0,0);
        }
      } 
      window.scrollTo(0,0);
    },formatMXN(value) {
      var formatter = new Intl.NumberFormat('en-ES', {style: 'currency', currency: 'USD',});
      // return formatter.format(value);
      return `${formatter.format(value)} MXN`;
    },seeProduct(value){   
      this.$router.push(`/shop/Product/${value}/home/${this.page}`);
    } 
  },
  
}
</script>
