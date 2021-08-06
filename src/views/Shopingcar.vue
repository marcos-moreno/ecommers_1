<template> 
  <div>
    <app-menu/>
  <v-container class="grey lighten-5" style="min-height:756px;"  >
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
    <template >
      <v-tabs >
        <v-tab>Carrito ({{shopingcarlength}})</v-tab> 
      </v-tabs>
    </template>
    <v-container class="my-12" v-if="shopingcarlength > 0">
      <div class="mb-16" no-gutters v-for="producto in productos" :key="producto.value" >
      
      <v-card class="mx-auto" >
        <v-row>
          <v-col cols="12" sm="6" md="8" >
            <v-row no-gutters>
              <v-col md="2">
                <v-img width="90" :src="`https://refividrio.com.mx/imgdis/${producto.value}.jpg`" :lazy-src="`../../public/noImg.png`"
                      aspect-ratio="1" class="grey lighten-2"> 
                <template v-slot:placeholder>
                  <v-row class="fill-height ma-0" align="center" justify="center">
                    <v-progress-circular indeterminate color="grey lighten-5" ></v-progress-circular>
                  </v-row>
                </template> 
              </v-img> 
                <!-- <v-img width="90" :src="producto.img" ></v-img>   -->
              </v-col> 
              <v-col >
                <div class="my-50"> 
                  <a style="color :#4E4E4E;font-size:1em;" 
                      @click="seeProduct(producto.value)" text color="primary" >
                    <strong>{{producto.name}}</strong> 
                  </a> 
                </div>
                <p class="font" style="font-size: 0.8em;" text color="primary" > 
                  {{producto.value}}
                </p> 
              </v-col> 
            </v-row>  
          </v-col> 
          <v-col sm="6" md="4"> 
            <v-row no-gutters>
              <v-col md="4">
                <!-- @click="qtyMovement(producto,'0')"  v-on:keyup="qtyMovement(producto,'0')"  -->
                <v-text-field class="centered-input text--darken-3 mt-3" 
                  v-model="producto.cantidad" type="number" label="Cantidad"
                  append-outer-icon="mdi-plus" 
                  @click:append-outer="qtyMovement(producto,'+')" 
                  @click:prepend="qtyMovement(producto,'-')"
                  @blur="qtyMovement(producto,'0')"
                  prepend-icon="mdi-minus"   
                  onkeydown="javascript: return event.keyCode == 69 ? false : true" 
                  style="min-width: 120px;height: 50px;font-size: .9em;"
                ></v-text-field>   
                <p class="font-weight-thin-black text-center" style="font-size: 0.85em;">
                  {{producto.mex_quantytotal}} {{producto.mex_quantytotal == 1 ?"disponible":"disponibles"}}
                  <center v-if="producto.total < producto.cantidad" style="font-size: .8em;color:#920505;">
                    {{(producto.total == 1) ? "El límite de compra es 1 pza." : `El límite de compra son ${producto.total} pzas.` }}
                  </center>
                </p> 
              </v-col> 
              <v-col> 
                <div class="font-black text-center" style=" font-size: 0.8em;">{{formatMXN(producto.l0)}} c/u.</div>
                <p class="font-black text-center" style=" font-size: 1.3em;">{{ formatMXN(producto.price) }}</p>
              </v-col> 
            </v-row>   
          </v-col> 
        </v-row>  
        <v-row no-gutters>   
          <v-container >  
            <v-row>
              <v-col> 
                <center><v-btn  text color="primary" @click="eliminarProducto(producto)" >Eliminar</v-btn></center>
              </v-col>
              <v-col cols="6"  > 
                  <div v-if="producto.mex_quantytotal < producto.cantidad" style="font-size: 0.8em; color:#F72D04"> 
                      <div v-if="((producto.mex_quantytotal - producto.cantidad)*-1)==1">
                        No hay stock disponible, se agregará 1 pza en forma de pedido.
                      </div>
                      <div v-else>
                        No hay stock disponible, se agregarán <strong>{{(producto.mex_quantytotal - producto.cantidad)*-1}}</strong> pzas en forma de pedido.
                      </div>
                  </div> 
              </v-col>
            </v-row>
          </v-container> 
        </v-row>  
      </v-card> 

      </div>  
        <v-container>
            <v-card class="mx-auto" style="min-height:186px;"> 
              <!-- <v-row>   -->
                <!-- <v-col class="mx-auto text-end"> 
                    Total <div style="font-size: 1em;color :#2DAD08">(Iva Incluido)</div>
                </v-col> -->
                <!-- <v-col class="mx-auto">  -->
                  <center  >
                    <br>
                  <div style="font-size: 1.4em;">
                    {{formatMXN(calculaTotalCar_fn())}}
                  <br>
                  Total
                    <div style="font-size: .8em;color :#2DAD08">(Iva Incluido)</div>
                   <br>
                  </div> 
                  </center>
                <!-- </v-col> -->
              <!-- </v-row> -->

              <v-row v-if="msgErro!=''" style="margin:20px" >  
                <v-col class="mx-auto text-center"> 
                  <v-alert dense outlined type="error" >
                    {{msgErro}}
                  </v-alert>
                </v-col>
              </v-row>

          
              <v-row>  
                <v-col class="mx-auto text-center"> 
                  <v-btn @click="completarComprar()" class="mx-auto" color="primary" width="60%" large>
                    CONTINUAR COMPRA
                  </v-btn>            
                </v-col> 
              </v-row> 
              
            </v-card> 
        </v-container> 
    </v-container>

    <v-container v-if="shopingcarlength == 0 && isLoad == false"  style="min-height:656px;"  >
      <div>
        <v-card style="min-height:186px;"> 
          <br><br>
            <p class="text-center my-5" style="font-size: 2em;color :#909090">  
             Tu carrito está vacío  
            </p> 
        </v-card> 
      </div>  
    </v-container>
  </v-container>  
  </div>
</template>

<style scoped>
    .centered-input >>> input {
      text-align: center
    }
</style>

<script>
import config from '../json/config.json'
import axios from 'axios'; 
import AppMenu from '../components/Menu.vue';

export default {
  name: "CrudDepartment",
  data() {
    return { 
      page: 1,
      productos : [],
      isLogged : false,
      user : {},
      isLoad : false, 
      msgErro : ""
    }; 
  }, 
  async created() {
    this.isLoad = true;  
    await this.validaLogin();
    if (this.isLogged) {
      await this.allProductinCar();
    }else{
      this.menu('/shop/Login/');  
    } 
    this.isLoad = false;  
  }
  ,components: { 
        'app-menu': AppMenu, 
  }
  ,methods: { 
    async mounted() {    
      window.scrollTo(0,0);
    },
    menu(path){
      if (this.$route.path !== path){
        this.$router.push(path);
      }  
    }, 
    async eliminarProducto(producto){
      this.isLoad = true;   
      await axios.delete(config.apiAdempiere + "/shopingcar/deletebyvalue_auth", 
      {
        headers:{token: this.$cookie.get('token')},
        data:{value: producto.value}
      })
      .then(res=>{ 
        if(res.data.status != "success"){
          console.log(res.data);
        } 
      }).catch(err=>{return console.log(err);});  
      await this.allProductinCar(); 
      document.getElementById("cantidadInCar").value = this.productos.length == 0?"":this.productos.length;
      this.isLoad = false;   
    },
    isInt(value) {
      var x;
      return isNaN(value) ? !1 : (x = parseFloat(value), (0 | x) === x);
    },
    completarComprar(){ 
      if (!this.validarProductos()) {
        this.msgErro = "Las cantidades de tu carrito no son válidas.";
      }else{
        this.msgErro = "";
        this.$router.push('/shop/Buy/')
      }
    },
    validarProductos(){
      for (let index = 0; index < this.productos.length; index++) {
        try {
          const element = this.productos[index];
          if (!this.isInt(element.cantidad) != element.cantidad < 1 || element.cantidad ==  "" || element.cantidad > element.total) {
            return false;
          } 
        } catch (error) {
          return false; 
        }
      }
      return true;
    },async qtyMovement(producto,vl){    
      this.isLoad = true;  
      try {
        if (this.isInt(producto.cantidad)) {
          if (vl == '+') {
            if (producto.cantidad >= producto.total) {
              producto.cantidad = producto.total; 
            }else{
              producto.cantidad = parseInt(producto.cantidad) + 1;
            } 
          }else  if (vl == '-') {
            if (parseInt(producto.cantidad) > 1) {
                producto.cantidad = parseInt(producto.cantidad) - 1;
            }
          }

          if (producto.cantidad < 0) {
             producto.cantidad = producto.cantidad * -1;
          }
          if (producto.cantidad >= producto.total) {
            producto.cantidad = producto.total; 
          }
        }else{
          if (producto.cantidad != "") {
            producto.cantidad = 0;
          }else{
            producto.price = 0.0;
            if (vl == '+') {
              producto.cantidad = 1;
            }else  if (vl == '-') { 
              producto.cantidad = 0;
            } 
          }
        }  
      } catch (error) { 
        console.log(error);
        producto.cantidad = 1;
      }  
      if (producto.cantidad != "" && this.isInt(producto.cantidad) ) {
        if(parseInt(producto.cantidad) > 0){
          await axios.put(config.apiAdempiere + "/shopingcar/updatebyvalue_auth", 
          {value: producto.value,cantidad : producto.cantidad}
          ,{headers:{'token': this.$cookie.get('token')}})
          .then(res=>{ if(res.data.status != "success")console.log(res.data);})
          .catch(err=>{return console.log(err);});     
          producto.price = producto.l0 * parseInt(producto.cantidad);
        } 
      }  
      if (!this.validarProductos()) {
        this.msgErro = "La cantidad de algun producto de tu carrito no es válida.";
      }else{
        this.msgErro = "";
      } 
      this.isLoad = false;  
    }
    ,async validaLogin(){
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
    ,async allProductinCar(){
        let productsincar = await axios.get(config.apiAdempiere + "/shopingcar/getcomplete_auth", 
        {
          'headers': { 'token': this.$cookie.get('token') }
        }).then(res=>{return res.data;})
        .catch(err=>{return err;}); 
        // console.log(productsincar);

        if (productsincar.status == "success") {
          productsincar = productsincar.data;
        }else if(this.user.status == "unauthorized"){  
          productsincar = [];
        }    
        for (let index = 0; index < productsincar.length; index++) { 
          productsincar[index].price = productsincar[index].l0 * productsincar[index].cantidad;  
          // let img = await axios.get(config.apiAdempiere + "/productos/imgByValue"
          //         ,{headers: { 'token': this.$cookie.get('token') },params: {filter: productsincar[index].value}})
          //         .then(function (response) {  
          //           return response.data.data;
          //         }).catch(function (response){  
          //           console.log(response);
          //           return response;
          //         });  
          // if (img.length == 1) {
          //   img = img[0].img;
          //   productsincar[index].img = 'data:image/jpeg;base64,' + btoa(
          //       new Uint8Array(img.data)
          //   .reduce((data, byte) => data + String.fromCharCode(byte), '')
          //   );  
          // }else{ 
          //   productsincar[index].img = "/noImg.png";
          // }
        }
        this.productos = productsincar;
    } 
    ,seeProduct(value){ 
      this.$router.push('/shop/Product/'+value+"/shopingcar/0");
    }
    ,formatMXN(value) { 
        var formatter = new Intl.NumberFormat('en-US', {style: 'currency', currency: 'USD'});
        return `${formatter.format(value)} MXN`;
    },
    calculaTotalCar_fn(){
      try {
        let total = 0;
        for (let index = 0; index < this.productos.length; index++) {
          try {
            const element = this.productos[index];
            let subtotal =  (parseInt(element.cantidad) * parseFloat(element.siniva) * 1.16000000).toFixed(2);
            total += parseFloat(subtotal);
          } catch (error) { 
            return null;
          } 
        }
        if (Number.isNaN(total)) {
          return 0;
        }else{
          return parseFloat(total).toFixed(2);  
        }
      } catch (error) {
        return 0;
      }
    },
  },
  computed:{ 
      shopingcarlength(){
          return this.productos.length;
      }, 
  },  
}
</script>
