<template> 
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
                <v-img width="90" :src="producto.img" ></v-img>  
              </v-col> 
              <v-col >
                <a class="font" style="color :#909090" @click="seeProduct(producto.value)" text color="primary" >
                  <strong>{{producto.name}}</strong><br>{{producto.value}}
                </a> 
              </v-col> 
            </v-row> 
            <v-row no-gutters  justify="center" >
              <v-btn text color="primary" class="my-10" @click="eliminarProducto(producto)" > Eliminar </v-btn>
            </v-row> 
          </v-col> 
          <v-col sm="6" md="4"> 
            <v-row no-gutters>
              <v-col md="4">
                <v-text-field class="centered-input text--darken-3 mt-3" 
                  v-model="producto.cantidad" type="number" label="Cantidad"
                  append-outer-icon="mdi-plus" @click:append-outer="qtyMovement(producto,'+')" 
                  prepend-icon="mdi-minus" @click:prepend="qtyMovement(producto,'-')" 
                  v-on:keyup="qtyMovement(producto,'0')" @click="qtyMovement(producto,'0')" 
                  onkeydown="javascript: return event.keyCode == 69 ? false : true" 
                ></v-text-field>  
                <p class="subtitle-2 text-center">{{producto.mex_quantytotal}} disponible</p>
              </v-col> 
              <v-col>
                <div class="font-black text-center" style=" font-size: 0.8em;">${{producto.l0}} c/u.</div>
                <p class="font-black text-center" style=" font-size: 1.8em;">{{ formatMXN(producto.price) }}</p>
              </v-col> 
            </v-row>  
            <v-row no-gutters v-if="producto.mex_quantytotal < producto.cantidad">
              <v-col>      
                <div class="font-weight-thin-black" style="font-size: 0.8em; color:#F72D04"> 
                  <div v-if="((producto.mex_quantytotal - producto.cantidad)*-1)==1">
                    No hay stock disponible, se agregará 1 pz en forma de pedido.
                  </div>
                  <div v-else>
                    No hay stock disponible, se agregarán <strong>{{(producto.mex_quantytotal - producto.cantidad)*-1}}</strong> pzs en forma de pedido.
                  </div>
                </div>
              </v-col> 
            </v-row>   
          </v-col>
        </v-row> 
        </v-card> 
      </div>  
        <v-container>
            <v-card class="mx-auto" style="min-height:186px;"> 
              <v-row>  
                <v-col class="mx-auto text-end"> 
                    Total <div style="font-size: 1em;color :#2DAD08">(Iva Incluido)</div>
                </v-col>
                <v-col class="mx-auto"> 
                  <div style="font-size: 1.8em;">{{calculaTotalCar}} </div> 
                </v-col>
              </v-row>

              <v-row v-if="msgErro!=''" >  
                <v-col class="mx-auto text-center"> 
                  <v-alert dense outlined type="error" >
                    {{msgErro}}
                  </v-alert>
                </v-col>
              </v-row>

          
              <v-row>  
                <v-col class="mx-auto text-center"> 
                  <v-btn @click="completarComprar" class="mx-auto" color="primary" width="60%" large>
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
            <p class="text-center" style="font-size: 2em;color :#909090">  
             Tu carrito está vacío  
            </p> 
        </v-card> 
      </div>  
    </v-container>
  </v-container>  
</template>

<style scoped>
    .centered-input >>> input {
      text-align: center
    }
</style>

<script>
import config from '../json/config.json'
import axios from 'axios'; 
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
        this.msgErro = "La cantidad de algun producto de tu carrito no es válida.";
      }else{
        this.msgErro = "";
        this.$router.push('/shop/Buy/')
      }
    },
    validarProductos(){
      for (let index = 0; index < this.productos.length; index++) {
        try {
          const element = this.productos[index];
          if (!this.isInt(element.cantidad) != element.cantidad < 1 || element.cantidad ==  "") {
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
            producto.cantidad = parseInt(producto.cantidad) + 1;
          }else  if (vl == '-') {
            if (parseInt(producto.cantidad) > 1) {
                producto.cantidad = parseInt(producto.cantidad) - 1;
            }
          } 
          if (producto.cantidad < 0) {
             producto.cantidad = producto.cantidad * -1;
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
        if (productsincar.status == "success") {
          productsincar = productsincar.data;
        }else if(this.user.status == "unauthorized"){  
          productsincar = [];
        } 
        for (let index = 0; index < productsincar.length; index++) { 
            productsincar[index].price = productsincar[index].l0 * productsincar[index].cantidad; 
            productsincar[index].img = 'data:image/jpeg;base64,' + btoa(
                new Uint8Array(productsincar[index].img.data)
                .reduce((data, byte) => data + String.fromCharCode(byte), '')
            );  
        } 
        this.productos = productsincar;
    } 
    ,seeProduct(value){ 
      this.$router.push('/shop/Product/'+value+"/shopingcar/0");
    }
    ,formatMXN(value) {
        var formatter = new Intl.NumberFormat('es-MX', {style: 'currency', currency: 'MXN',});
        return formatter.format(value);
    }  
  }, 
  computed:{ 
      shopingcarlength(){
          return this.productos.length;
      },
      calculaTotalCar(){
        let total = 0;
        for (let index = 0; index < this.productos.length; index++) {
          const element = this.productos[index];
          total += element.cantidad * element.l0;
        }
        return this.formatMXN(total);
      },
  },
  watch: {
  
  } 
  
}
</script>
