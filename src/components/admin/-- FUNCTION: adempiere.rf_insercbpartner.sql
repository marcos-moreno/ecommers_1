-- FUNCTION: adempiere.rf_order_ecomers(integer, integer, integer, numeric, character varying, integer, json)

-- DROP FUNCTION adempiere.rf_order_ecomers(integer, integer, integer, numeric, character varying, integer, json);

CREATE OR REPLACE FUNCTION adempiere.rf_order_ecomers(
	vidlistaprecios integer,
	vad_org_id integer,
	vid_alm integer,
	vgrandtotal numeric,
	vorderecommrs character varying,
	vidsocio integer,
	product_collection json)
    RETURNS TABLE(c_order_id integer, documentno character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$ 

 DECLARE   
 vIdOrder INTEGER =0;
 vidsocioOriginal INTEGER =0;
 vFechaDoc DATE DEFAULT NULL;    
 vPrefijoDoc CHARACTER VARYING;
 vNodcument CHARACTER VARYING;
 vConsecDoc INTEGER;
 vTipoDoc INTEGER;
 vIDMoneda INTEGER = 130 ;

 --------var Socio de negocio 
 vIDDirSocio INTEGER DEFAULT 0;
 -- vIDListaPrecios INTEGER DEFAULT 0;
  --------End var Socio de negocio

--Valores de la linea
vIdOrderline INTEGER DEFAULT 0; 
vline INTEGER = 10; 
vc_uom_id INTEGER DEFAULT 0;
--Valores de la linea
vtotallines numeric = ROUND((vgrandtotal/1.16)::numeric,2);

reg_product RECORD;

cur_products CURSOR
	FOR SELECT * FROM json_to_recordset(product_collection) as x
	(m_product_id numeric, total numeric, price numeric, quantity numeric);

BEGIN
  SET search_path to adempiere;
  
  
	-- vIDListaPrecios = (SELECT m_pricelist_id FROM c_bpartner WHERE  c_bpartner_id = vIDSocio limit 1);
	vIDDirSocio = (SELECT MAX(c_bpartner_location_id)  FROM c_bpartner_location WHERE c_bpartner_id = vIDSocio AND isactive = 'Y' AND ad_client_id = 1000000);

	vIdOrder = (SELECT adempiere.nextidfunc(232, 'N'));
	vFechaDoc = NOW()::DATE;  
  
  
	vTipoDoc = 1000857; -- <-- Orden estandar --- ORDEN DIRECTA --> 1000856
	  
	vPrefijoDoc = (SELECT  prefix FROM C_DocType doc INNER JOIN AD_Sequence  seq ON seq.AD_Sequence_ID=  doc.docnosequence_id   WHERE C_DocType_id = vTipoDoc);
	
	vConsecDoc = (SELECT DocNoSequence_ID FROM  C_DocType WHERE C_DocType_ID = vTipoDoc);

	vNodcument = vPrefijoDoc || adempiere.nextidfunc(vConsecDoc, 'N');
 	
	
	   INSERT INTO C_Order 
		(
			c_order_id, ad_client_id, ad_org_id, isactive, created, createdby, updated, updatedby, 
			issotrx, documentno, docstatus, docaction, processing, processed, 
			c_doctype_id, c_doctypetarget_id, description, isapproved, iscreditapproved, 

			isdelivered, isinvoiced, isprinted, istransferred, isselected, salesrep_id, 
			dateordered, datepromised, dateacct, c_bpartner_id, c_bpartner_location_id, 
			isdiscountprinted, c_currency_id, paymentrule, c_paymentterm_id, invoicerule, 

			deliveryrule, freightcostrule, freightamt, deliveryviarule, chargeamt, priorityrule, 
			totallines, grandtotal, m_warehouse_id, m_pricelist_id, istaxincluded, posted, 
			sendemail, copyfrom, isselfservice, c_conversiontype_id, bill_bpartner_id, bill_location_id, 
			isdropship, volume, weight, amounttendered, amountrefunded, processedon, printformattype

			,generatelist,rf_printletterorder,dopricing,isbillingdate
		)

		VALUES (
			vIdOrder,1000000,vad_org_id,'Y',now()::DATE,1000035,now()::DATE,1000035,
			'Y', vNodcument,'DR','CO','N','N',
			--0,
			vTipoDoc,vTipoDoc,'E-COMMERS INTERNO Id. VENTA: ' || vOrderEcommrs,'Y','N',

			'N','N','N','N','N',1000035,
			vFechaDoc,vFechaDoc,vFechaDoc,vIDSocio,vIDDirSocio, --Fechas y Socio
			'Y',vIDMoneda,'P',(SELECT C_PaymentTerm_ID FROM C_BPartner WHERE c_bpartner_id = vIDSocio Limit 1),'I', --Moneda, Dias Credito

			'A','I',0,'D',0,5,
			vTotalLines,vGrandTotal,vid_alm,vIDListaPrecios,'N','N', --Almacen,ListaDePrecios
			'N','N','N',114,vIDSocio,vIDDirSocio, --Socio
			'N',0,0,'0.0','0.0',0,'N'

			,'N','N','N','N'
		);
 		--ORDEN 
		 
 	INSERT INTO C_OrderTax
	(
		c_order_id, c_tax_id, ad_client_id, ad_org_id, isactive, created, createdby, updated, updatedby, 
		taxbaseamt, taxamt, processed, istaxincluded
	)
	VALUES 
	(
		vIdOrder,1000001,1000000,vad_org_id,'Y',now()::DATE,1009429,now()::DATE,1009429,
		vTotalLines,ROUND((vgrandtotal-(vgrandtotal/1.16))::numeric,2),'Y','N'
	);

	OPEN cur_products;
	LOOP 
      FETCH cur_products INTO reg_product; 
      EXIT WHEN NOT FOUND;
		
		 RAISE NOTICE 'Calling####(%)',  reg_product;
		 vc_uom_id = (SELECT c_uom_id FROM m_product WHERE m_product_id = reg_product.m_product_id);
		 vIdOrderline = (SELECT adempiere.nextidfunc(233, 'N')); 
    	 INSERT INTO C_OrderLine
				(c_orderline_id, ad_client_id, ad_org_id, isactive, created, createdby, updated, updatedby, c_order_id, 
				 line, c_bpartner_id, c_bpartner_location_id, dateordered, datepromised, m_product_id, 
				 m_warehouse_id, c_uom_id, qtyordered, qtyreserved, qtydelivered, qtyinvoiced, 
				 
				 c_currency_id,
				 pricelist,
				 priceactual, 
				 pricelimit, 
				 linenetamt, 
				 discount, freightamt, 
				 c_tax_id, m_attributesetinstance_id, isdescription, processed, qtyentered, 
				 priceentered, pricecost, qtylostsales, rramt, isconsumesforecast, createfrom, createshipment, pickedqty)
			VALUES 
			(
				vIdOrderline,1000000,vad_org_id,'Y',now()::DATE,1000035,now()::DATE,1000035,vIdOrder, --vIdOrder
				vline,vIDSocio,vIDDirSocio,vFechaDoc,vFechaDoc,reg_product.m_product_id, --linea,socio,locationID,fecha,fecha,m_product_id
				vid_alm,vc_uom_id,reg_product.quantity,0,0,0, --Almacen,unidadMedida,cantidad
				
				vIDMoneda --Moneda,PrecioLista
				,ROUND((reg_product.price/1.16)::numeric,2)
				,ROUND((reg_product.price/1.16)::numeric,2)
				,ROUND((reg_product.price/1.16)::numeric,2)
				,ROUND((reg_product.total/1.16)::numeric,2)
				,'0.0',0, 

				1000001,0,'N','N', reg_product.quantity , --Impuesto,attributos,CANTIDAD

				ROUND((reg_product.price/1.16)::numeric,2) ,0,0,0,'N','N','N',0 --PRECIO
			); 
			vline = vline + 10;
    END LOOP;
	
    CLOSE cur_products;
  	
	RETURN QUERY
  		SELECT  vIdOrder,vNodcument;
END;
$BODY$;

ALTER FUNCTION adempiere.rf_order_ecomers(integer, integer, integer, numeric, character varying, integer, json)
    OWNER TO postgres;
