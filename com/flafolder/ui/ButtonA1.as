﻿/*

   Code    	: Button
   Version 	: A1

   Year    	: January 2012
   Autor	: Buğra ÖZDEN
   Mail    	: bugra.ozden@gmail.com
   Site    	: flafolder.com


   You are free:

   to Share — to copy, distribute and transmit the work
   to Remix — to adapt the work
   to make commercial use of the work
   
   <http://creativecommons.org/licenses/by/3.0/>


   ( Comments written in Turkish. )

 */

package com.flafolder.ui
{
	import com.flafolder.ui.buttonA1.*;
	
	import flash.utils.*
	import fl.core.UIComponent;
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.ui.Mouse;
	
	public class ButtonA1 extends UIComponent
	{
		public static const EFFECT:ButtonA1Effect = (EFFECT == null) ? new ButtonA1Effect() : EFFECT;
		public static const FRAME:ButtonA1Frame = (FRAME == null) ? new ButtonA1Frame() : FRAME;
		public static const STYLE:ButtonA1Style = (STYLE == null) ? new ButtonA1Style() : STYLE;
		public static const DEFAULT:ButtonA1Default = (DEFAULT == null) ? new ButtonA1Default() : DEFAULT;
		public static const ANTIALIAS:ButtonA1AntiAlias = (ANTIALIAS == null) ? new ButtonA1AntiAlias() : ANTIALIAS;
				
		private static const _frameName_array:Array = new Array("up", "over", "down", "disable");
		private static const _iconName_array:Array = new Array("leftIcon", "rightIcon");
		private static const _antiAlias_array:Array = new Array("use device fonts", "normal", "advanced", "bitmap text");
		private static const _effectProp_array:Array = new Array("", "alpha", "x", "y", "x", "y");
		private static const _effectValue_array:Array = new Array("", "alpha", "width", "height", "width", "height");
		
		private var _me:MovieClip; //button nesnesi.
		private var _mask_mc:MovieClip; //maske nesnesi.
		private var _leftIcon_mc:MovieClip;
		private var _rightIcon_mc:MovieClip;
		
		public var id:String; //buttonun tutmasını istediğini bir id.
		private var _width_num:Number; //buttonun genişliği,
		private var _height_num:Number; //yüksekliği
		private var _autoWidth_bool:Boolean; //true: otomatik genişlik.
		private var _autoHeight_bool:Boolean; //true: otomatik yükseklik.
		private var _enabled_bool:Boolean; //true: button aktif.
		private var _url_str:String; //butona tıklandığında açılacak url.
		private var _target_str:String; //url açılma şekli ( _blank, _self ).
		private var _effect_num:uint; //geçiş hareket tipi.
		private var _rightIcon_obj:Object; //sağ ikon.
		private var _leftIcon_obj:Object; //sol ikon.
		private var _feed_xml:XMLList; //tüm özellikleri içeren xml.
		private var _overSound_sound:Sound; //üzerine gelince çalacak ses.
		private var _downSound_sound:Sound; //basınca çalacak ses.
		private var _usingSkin_obj:Object; //kullanılan skin.
		private var _frame_str:String; //bulunduğu framein ismi.
		private var _toggleButton_bool:Boolean;
		private var _toggleValue_bool:Boolean;
		private var _autoDraw_bool:Boolean;
		private var _button_bool:Boolean;
		private var _handCursor_bool:Boolean;
		
		private var _label_str:String; //buttonun görünen metni.
		private var _labelAlign_str:String; //metnin hizalanması.
		private var _fontName_str:String; //metnin font ismi.
		private var _fontSize_num:uint; //fontun boyutu.
		private var _fontBold_bool:Boolean;
		private var _embedFont_bool:Boolean; //true: gömülü font ile çalış.
		private var _antiAlias_num:uint;
		private var _leftIconSpace_num:uint;
		private var _rightIconSpace_num:uint;
		
		private var _topSpace_num:uint; //button kenar boşlukları.
		private var _leftSpace_num:uint;
		private var _rightSpace_num:uint;
		private var _bottomSpace_num:uint;
		private var _labelLeftSpace_num:uint; //metin kenar boşlukları.
		private var _labelRightSpace_num:uint;
		
		public static var effectSpeed:uint; //hareketleri oluşturan kare sayısı.
		private var _obj1_tween:Tween; //hareket değişkenleri.
		private var _obj0_tween:Tween;
		private var _obj1Move_tween:Tween;
		private var _obj0Move_tween:Tween;
		
		/*

		Sistem Fonksiyonları
		
		*/
		
		public function ButtonA1()
		{
			//kod
		}
		
		override protected function configUI():void
		{		
			super.configUI();

			//kordinatları yuvarla
			x = int(x);
			y = int(y);
			
			//mask nesnesini oluştur.
			_mask_mc = new MovieClip();
			_mask_mc.graphics.beginFill(0xFFFFFF);
			_mask_mc.graphics.drawRect(0, 0, 60, 22);
			_mask_mc.graphics.endFill();
			_mask_mc.alpha = 0;
			_mask_mc.x = 0;
			_mask_mc.y = 0;
			addChild(_mask_mc);
			
			resetToDefault();
		}
		
		override protected function draw():void
		{
			try {
			
			//sahnedeki boyutları al.
			_width_num = Math.round(super.width);
			_height_num = Math.round(super.height);
			
			//eğer feed xml kaynağı var ise. 
			if (_feed_xml != null)
			{
				//tüm bilgileri oradan al.
				_getFromFeed();
			}
			
			//görünümü güncelle.
			_addSkin();
			
			//ikonları güncelle.
			_getIcons();
			
			//sesleri güncelle.
			_getSounds();
			
			var __master:MovieClip = _me[FRAME.UP];
			
			//yazının aling özelliği
			var __format1_textFormat:TextFormat = new TextFormat();
			__format1_textFormat.align = _labelAlign_str;
			__format1_textFormat.size = _fontSize_num;
			__format1_textFormat.bold = _fontBold_bool;
			
			//standart özellikler.
			__format1_textFormat.font = _fontName_str;
			_embedFont_bool = true;
			
			switch (_antiAlias_num)
			{
				//sistemdeki fontlar ile çalış.
				case ANTIALIAS.USE_DEVICE_FONTS: 
					_embedFont_bool = false;
					break;
					
				//fontu dosyanın içine gömerek çalış.
				case ANTIALIAS.BITMAP_TEXT: 
					__format1_textFormat.font = _fontName_str + "_" + _fontSize_num + "pt_st";
					break;
				case ANTIALIAS.NORMAL: 
					break;
				case ANTIALIAS.ADVANCED: 
					break;
			}
			
			//icon genişlikleri
			var __rightIconHeight:int;
			var __rightIconWidth:int;
			
			if (_rightIcon_mc != null)
			{
				//icon var bilgilerini al.
				__rightIconHeight = Math.round(_rightIcon_mc.height);
				__rightIconWidth = Math.round(_rightIcon_mc.width);
				__rightIconWidth += (_label_str != "") ? _labelRightSpace_num : 0;
			}
			else
			{
				//icon yok.
				__rightIconHeight = 0;
				//icon boşluğu var ise, label-icon arasındaki boşluğuda ekle.
				__rightIconWidth = (_rightIconSpace_num != 0) ? _rightIconSpace_num + _labelRightSpace_num : 0;
			}
			
			var __leftIconHeight:int;
			var __leftIconWidth:int;
			
			if (_leftIcon_mc != null)
			{
				//icon var bilgilerini al.
				__leftIconHeight = Math.round(_leftIcon_mc.height);
				__leftIconWidth = Math.round(_leftIcon_mc.width);
				__leftIconWidth += (_label_str != "") ? _labelLeftSpace_num : 0;
			}
			else
			{
				//icon yok.
				__leftIconHeight = 0;
				//icon boşluğu var ise, label-icon arasındaki boşluğuda ekle.
				__leftIconWidth = (_leftIconSpace_num != 0) ? _leftIconSpace_num + _labelLeftSpace_num : 0;
			}

			//text dışı genişlikler.
			var __totalWidth:int = _leftSpace_num + _rightSpace_num + __rightIconWidth + __leftIconWidth;

			//otomatik yükseklik olursa en yüksek nesnenin yüksekliğini al.
			var __totalHeight:int = (__leftIconHeight > __rightIconHeight) ? __leftIconHeight : __rightIconHeight;

			//ikonlar için alttan üsten biraz boşluk ekle.
			__totalHeight += _topSpace_num + bottomSpace;

			//text genişlik yükseklik						
			var __textWidth:int;
			var __textHeight:int;
			
			//Textlerin içeriğini güncelle
			__master.labelTxt.htmlText = _label_str;
			//Yazıyı multiline veya tek satır yap.
			__master.labelTxt.multiline = !_autoWidth_bool;
			__master.labelTxt.wordWrap = !_autoWidth_bool;
			//device font olmasın
			__master.labelTxt.embedFonts = _embedFont_bool;

			//fontun anti alias özelliği
			if (_antiAlias_num == ANTIALIAS.ADVANCED)
				__master.labelTxt.antiAliasType = _antiAlias_array[_antiAlias_num]
			else
				__master.labelTxt.antiAliasType = _antiAlias_array[ANTIALIAS.NORMAL];
				
			//Yazı formatını ayarla
			__master.labelTxt.setTextFormat(__format1_textFormat);
			//otomatik yazı genişliği
			__master.labelTxt.autoSize = TextFieldAutoSize.LEFT;
			
			//eğer text boş ise genişlik ve yüksekliği 0 yap.
			if (_label_str != "")
			{
				//otomatik ayarlanmış text genişliğini ve yüksekliğini al.
				__textWidth = Math.round(__master.labelTxt.width);
				__textHeight = Math.round(__master.labelTxt.height);
				
				//text dolu ise texti referans al.
				__totalHeight = __textHeight;
			}
			else
			{
				__textWidth = 0;
				__textHeight = 0;
			}
			
			//genişlik otomatik ise
			if (_autoWidth_bool)
			{
				// Her parçanın genişliğini text in genişliğine eşitle
				_width_num = __master.back.width = __textWidth + __totalWidth;
			}
			else
			{
				//yazı genişliğini ayarla
				__master.labelTxt.width = __textWidth = _width_num - __totalWidth;
				
				if (_label_str != "")
				{
					//text yüksekliği değişti.
					__textHeight = __master.labelTxt.height;
					//totalheight güncelle.
					__totalHeight = __textHeight;
				}
				
				//button genişliğini ayarla
				__master.back.width = _width_num;
			}
			
			//leftIcon sol boşluk ayarla.
			__master[STYLE.LEFT_ICON].x = _leftSpace_num;
			//yazının sol boşluğunu ayarla.
			__master.labelTxt.x = __leftIconWidth + _leftSpace_num;
			//rightIcon sol boşluk ayarla.
			__master[STYLE.RIGHT_ICON].x = _width_num - __rightIconWidth - _rightSpace_num + _labelRightSpace_num;
			
			//otomatik yükseklik ise
			if (_autoHeight_bool)
			{
				//yazının üst boşluğu
				__master.labelTxt.y = _topSpace_num;
				//button yüksekliğini otomatik ayarla
				__master.back.height = __totalHeight + _topSpace_num + _bottomSpace_num;
				//Eğer button çok satırlı ise altı (_bottomSpace_num + 2) kadar uzat.

				__master.back.height += (__master.labelTxt.numLines > 1) ? (_bottomSpace_num + 2) : 0;
				//yüksekliği ayarla
				_height_num = __master.back.height;
			}
			else
			{
				//yazının üst boşluğunu hesapla
				__master.labelTxt.y = Math.round((_height_num - __textHeight) / 2);
				//button yüksekliğini ayarla
				__master.back.height = _height_num;
			}
			
			//leftIcon üst boşluk ayarla.
			__master[STYLE.LEFT_ICON].y = Math.round((_height_num - __leftIconHeight) / 2);
			//rightIcon üst boşluk ayarla.
			__master[STYLE.RIGHT_ICON].y = Math.round((_height_num - __rightIconHeight) / 2);

			//her frame parçasını birincisini referans alarak güncelle.
			for each (var __backName:String in _frameName_array)
			{
				if (__backName != FRAME.UP)
				{
					with (_me[__backName])
					{
						//belirlenen özellikleri tüm nesnelere ver.
						back.width = __master.back.width;
						back.height = __master.back.height;
						labelTxt.width = __master.labelTxt.width;
						labelTxt.height = __master.labelTxt.height;
						labelTxt.x = __master.labelTxt.x;
						labelTxt.y = __master.labelTxt.y;
						leftIcon.x = __master.leftIcon.x;
						leftIcon.y = __master.leftIcon.y;
						rightIcon.x = __master.rightIcon.x;
						rightIcon.y = __master.rightIcon.y;
						labelTxt.htmlText = _label_str;
						labelTxt.multiline = !_autoWidth_bool;
						labelTxt.wordWrap = !_autoWidth_bool;
						labelTxt.embedFonts = _embedFont_bool;
						labelTxt.antiAliasType = __master.labelTxt.antiAliasType;
						labelTxt.setTextFormat(__format1_textFormat);
					}
				}
			}
			
			//space ve white'ı boyutlandır.
			_me.space.width = _me.white.width = _mask_mc.width = _width_num;
			_me.space.height = _me.white.height = _mask_mc.height = _height_num;
			
			//ilk çizimden sonra otomatik çizimi aç.
			_autoDraw_bool = true;
			
			super.draw();
			}
			catch (e:Error)
			{
					trace(e.message);
			}
		}
		
		/*

		Fonksiyonlar
		
		*/
		
		private function _getFromFeed():void 
		{
			//değişkenleri xml listesindeki veriler ile güncelle.
			autoDraw = false;
			if (_feed_xml.labelAlign != "") labelAlign = _feed_xml.labelAlign;
			if (_feed_xml.autoWidth != "") autoWidth = Boolean(uint(_feed_xml.autoWidth));
			if (_feed_xml.autoHeight != "") autoHeight = Boolean(uint(_feed_xml.autoHeight));
			if (_feed_xml.width != "") width = Number(_feed_xml.width);
			if (_feed_xml.height != "") height = Number(_feed_xml.height);
			if (_feed_xml.fontName != "") fontName = _feed_xml.fontName;
			if (_feed_xml.fontSize != "") fontSize = Number(_feed_xml.fontSize);
			if (_feed_xml.fontBold != "") fontBold = Boolean(uint(_feed_xml.fontBold));
			if (_feed_xml.effect != "") effect = uint(_feed_xml.effect);
			if (_feed_xml.antiAlias != "") antiAlias = uint(_feed_xml.antiAlias);
			if (_feed_xml.urlTarget != "") urlTarget = _feed_xml.urlTarget;
			if (_feed_xml.toggleButton != "") toggleButton = Boolean(uint(_feed_xml.toggleButton));
			if (_feed_xml.buttonMode != "") buttonMode = Boolean(uint(_feed_xml.buttonMode));
			if (_feed_xml.useHandCursor != "") useHandCursor = Boolean(uint(_feed_xml.useHandCursor));
			//boşluklar
			if (_feed_xml.labelLeftSpace != "") labelLeftSpace = uint(_feed_xml.labelLeftSpace);
			if (_feed_xml.labelRightSpace != "") labelRightSpace = uint(_feed_xml.labelRightSpace);
			if (_feed_xml.leftIconSpace != "") leftIconSpace = uint(_feed_xml.leftIconSpace);
			if (_feed_xml.rightIconSpace != "") rightIconSpace = uint(_feed_xml.rightIconSpace);
			if (_feed_xml.topSpace != "") topSpace = uint(_feed_xml.topSpace);
			if (_feed_xml.bottomSpace != "") bottomSpace = uint(_feed_xml.bottomSpace);
			if (_feed_xml.leftSpace != "") leftSpace = uint(_feed_xml.leftSpace);
			if (_feed_xml.rightSpace != "") rightSpace = uint(_feed_xml.rightSpace);
			_feed_xml = null;
			autoDraw = true;
		}
		
		private function resetToDefault():void 
		{
			//komponentin standart özellikleri
			_label_str = "Button Label";
			_frame_str = FRAME.UP;
			_fontName_str = DEFAULT.FONT_NAME;
			_fontSize_num = DEFAULT.FONT_SIZE;
			_labelAlign_str = DEFAULT.LABEL_ALIGN;
			_antiAlias_num = DEFAULT.ANTI_ALIAS;
			_effect_num = EFFECT.ALPHA;
			_target_str = DEFAULT.URL_TARGET;
			_url_str = "";
			_fontBold_bool = true;
			_embedFont_bool = false;
			_enabled_bool = true;
			_autoWidth_bool = true;
			_autoHeight_bool = true;
			_toggleButton_bool = false;
			_toggleValue_bool = false;
			_autoDraw_bool = false;
			_button_bool = true;
			_handCursor_bool = true;
			_leftIconSpace_num = DEFAULT.LEFT_ICON_SPACE;
			_rightIconSpace_num = DEFAULT.RIGHT_ICON_SPACE;
			
			//label boşlukları
			_topSpace_num = DEFAULT.TOP_SPACE;
			_leftSpace_num = DEFAULT.LEFT_SPACE;
			_rightSpace_num = DEFAULT.RIGHT_SPACE;
			_bottomSpace_num = DEFAULT.BOTTOM_SPACE;
			_labelLeftSpace_num = DEFAULT.LABEL_LEFT_SPACE;
			_labelRightSpace_num = DEFAULT.LABEL_RIGHT_SPACE;
			
			effectSpeed = DEFAULT.EFFECT_SPEED;
		}
		
		//skini sahneye ekler.
		private function _addSkin():void
		{
			//ayarlanan skin ismini al.
			var __newSkin:Object = getStyleValue(STYLE.SKIN);
			
			//eğer null ise default skin demektir.
			if (__newSkin == null)
			{
				//default skini al.
				__newSkin = getDefinitionByName(DEFAULT.SKIN_NAME) as Object;
			}
			
			//eğer skin değiştirilmiş ise.
			if (_usingSkin_obj != __newSkin)
			{
				//eğer daha önceden sahneye eklenmiş bir skin varsa.
				if (_me != null && contains(_me))
				{
					//skini sil.
					removeChild(_me);
					_me = null;
				}

				//yeni skini sahneye ekle.
				_me = addChild(new __newSkin) as MovieClip;
				
				//bulunduğu frame'e git.
				_goto(_frame_str);
				//maskele.
				_addMask();
				//güncelle.
				_usingSkin_obj = __newSkin;
				//olayları oluştur.
				_controlListeners(_button_bool);
			}
		}
		
		//skinin üzerine mask yapar.
		private function _addMask()
		{
			//mask nesnesini en üste al.
			setChildIndex(_mask_mc, numChildren - 1);

			//mask nesnesi oluşturulmuş ve sahneye eklenmiş ise.
			if (_mask_mc != null && contains(_mask_mc))
			{
				_me.mask = _mask_mc;
			}
		}
		
		//iconları sahneye ekleyen fonksiyonları çalıştırır.
		private function _getIcons():void
		{
			_getIcon(STYLE.LEFT_ICON);
			_getIcon(STYLE.RIGHT_ICON);
		}
		
		//iconları sahneye ekler.
		private function _getIcon($iconName:String):void
		{
			//varsayılan iconu al.
			var __icon_obj:Object = getStyleValue($iconName);
			//icon nesnesi
			var __icon_mc:MovieClip;
			//obje null değilse MovieClip yap.
			if (__icon_obj != null)
				__icon_mc = (__icon_obj is Class) ? (new __icon_obj) as MovieClip : (__icon_obj) as MovieClip;
			//icon değişkeninin adı.
			var __iconVarName:String = "_" + $iconName + "_mc";
			
			//eğer icon değiştirilmiş ise;
			if (__icon_mc != this[__iconVarName])
			{
				//nesneleri sahneden kaldır.
				_removeIcon($iconName);
				//değişkeni temizle.
				this[__iconVarName] = null;
				//yeni obje boş değilse.
				if (__icon_obj != null)
				{
					//nesneyi ilgili değişkene al.
					this[__iconVarName] = __icon_mc;
					//yeni atanan iconu ekle.
					_addIcons(_frame_str);
					//eklenen ikona ismi ver.
					this[__iconVarName].name = $iconName;
				}
			}
		}
		
		private function _addIcons($frameName:String):void
		{
			for each (var __iconName:String in _iconName_array)
			{
				var __iconVarName:String = "_" + __iconName + "_mc";
				
				//icon var ise
				if (this[__iconVarName] != null)
				{
					//ikonu ekle.
					_me[$frameName][__iconName].addChild(this[__iconVarName]);
				}
			}
		}
		
		private function _removeIcon($iconName:String):void
		{
			//tüm parçaların içinde
			for each (var __backName:String in _frameName_array)
			{
				//nesne varsa sil.
				if (_me[__backName][$iconName].numChildren > 0)
					_me[__backName][$iconName].removeChildAt(0);
			}
		}
		
		private function _getSounds()
		{
			//ses dosyalarını al.
			_overSound_sound = getStyle(STYLE.OVER_SOUND) as Sound;
			_downSound_sound = getStyle(STYLE.DOWN_SOUND) as Sound;
		}
		
		/*

		Hareket kontrol
		
		*/
		
		// hareketsiz frame değiştirme fonksiyonu.
		private function _goto($frameName:String):void
		{
			//gidilen frame ismi
			_frame_str = $frameName;
			//button nesnesi var ise.
			if (_me != null)
			{
				// iconun yerini değiştir.
				_addIcons($frameName);
				//button özelliği, up ise button ol, diğer durumlarda button özelliğini kapat.
				//ama toggle button ise button özelliğini kapatma.
				if (!_toggleButton_bool) {
					buttonMode = (_frame_str == FRAME.UP && _button_bool == true) ? true : false;
				}else {
					//toggle Button ise sadece enabled false olduğunda button olmasın.
					buttonMode = (enabled) ? true : false;
					}
				//hareketsiz olarak frame e git.
				for each (var __backName:String in _frameName_array)
				{
					_me[__backName].alpha = (__backName != $frameName) ? 0 : 1;
				}
			}
		}
		
		private function _effectTo($objectName:String):void
		{
			// iconun yerini değiştir.
			_addIcons($objectName);
			
			//gelen nesneyi göster, görüneni sakla.
			for each (var __backName:String in _frameName_array)
			{
				if (__backName == $objectName)
					_doEffect(_me[__backName], _effect_num, true)
				else if (_me[__backName].alpha > 0)
					_doEffect(_me[__backName], _effect_num, false);
			}
		}
		
		private function _finishEffect($tween:Tween):void
		{
			//eğer tween de animasyon devam ediyorsa onu sonlandır.
			if ($tween != null)
				if ($tween.isPlaying)
				{
					$tween.fforward();
					$tween = null;
				}
		}
		
		private function _doEffect($target:Object, $animationType:uint, $show:Boolean):void
		{
			//nesnenin kordinatlarını başlangıç kordinatına getir.
			$target.x = 0;
			$target.y = 0;
			
			//gelirken iki kat daha hızlı olsun.
			var __effectSpeed:int = effectSpeed;
			if ($target.name == FRAME.UP && $show || 
				$target.name == FRAME.OVER && !$show)
			{
				//code
			}
			else
			{
				__effectSpeed = int(effectSpeed / 2);
			}
			
			//animasyon tipine göre çalış
			if ($animationType == 0)
			{
				//hareketsiz olarak değiş.
				$target.alpha = int($show);
			}
			else
			{
				//hareketli ise daima alpha özelliğini kullan.
				var __obj:String = "_obj" + Number($show).toString() + "_tween";
				_finishEffect(this[__obj]);
				
				this[__obj] = new Tween($target, 
										"alpha", 
										Strong.easeOut, 
										Number(!$show), 
										Number($show), 
										__effectSpeed, 
										false);
				
				//alpha dışında ise hareketi gerçekleştir.
				if ($animationType != 1)
				{
					//hareketin yönünü belirleyen değişken.
					var __effectWay:int = ($animationType > 3) ? -1 : 1;
					
					var __objMove:String = "_obj" + Number($show).toString() + "Move_tween";
					_finishEffect(this[__objMove]);
					
					//nesnenin kordinat hareketleri.
					this[__objMove] = new Tween($target, 
					_effectProp_array[$animationType], 
					Strong.easeOut, 
					$target[_effectValue_array[$animationType]] * Number($show) * __effectWay, 
					$target[_effectValue_array[$animationType]] * Number(!$show) * __effectWay * -1, 
					__effectSpeed, false);
				}
			}
		}
		
		/*

		Özellikler
		
		*/
		
		//label
		[Inspectable(type="String",defaultValue="Button Label")]
		public function get label():String
		{
			return _label_str;
		}
		
		public function set label($text:String):void
		{
			if (_label_str != $text)
			{
				_label_str = $text;
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//labelAlign
		[Inspectable(category="Main",defaultValue="center",enumeration="left,center,right")] //justify
		public function get labelAlign():String
		{
			return _labelAlign_str;
		}
		
		public function set labelAlign($textFormatAlign:String):void
		{
			if (_labelAlign_str != $textFormatAlign)
			{
				_labelAlign_str = $textFormatAlign;
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//frame
		public function get frame():String
		{
			return _frame_str;
		}
		
		public function set frame($frameName:String):void
		{
			if (!_toggleButton_bool){
				if (_frame_str != $frameName)
					_goto($frameName);
			}
			else
			{
				//trace("Error: You can't change frame while toggleButton is true.");
			}
		}
		
		//width
		override public function get width():Number
		{
			return _width_num;
		}
		
		override public function set width($value:Number):void
		{
			autoWidth = false;
			super.width = $value;
			_width_num = super.width;
		}
		
		//height
		override public function get height():Number
		{
			return _height_num;
		}
		
		override public function set height($value:Number):void
		{
			autoHeight = false;
			super.height = $value;
			_height_num = super.height;
		}
		
		//autoWidth
		[Inspectable(type="Boolean",defaultValue=true)]
		public function get autoWidth():Boolean
		{
			return _autoWidth_bool;
		}
		
		public function set autoWidth($value:Boolean):void
		{
			if (_autoWidth_bool != $value)
			{
				_autoWidth_bool = $value;
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//autoHeight
		[Inspectable(type="Boolean",defaultValue=true)]
		public function get autoHeight():Boolean
		{
			return _autoHeight_bool;
		}
		
		public function set autoHeight($value:Boolean):void
		{
			if (_autoHeight_bool != $value)
			{
				_autoHeight_bool = $value;
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//autoDraw
		public function get autoDraw():Boolean
		{
			return _autoDraw_bool;
		}
		
		public function set autoDraw($value:Boolean):void
		{
			_autoDraw_bool = $value;
		}
		
		//fontName
		[Inspectable(type="Font Name",defaultValue="Arial")]
		public function get fontName():String
		{
			return _fontName_str;
		}
		
		public function set fontName($fontName:String):void
		{
			if (_fontName_str != $fontName)
			{
				_fontName_str = $fontName;
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//fontSize
		[Inspectable(type="Number",defaultValue=11)]
		public function get fontSize():Number
		{
			return Number(_fontSize_num);
		}
		
		public function set fontSize($fontSize:Number):void
		{
			//yazı en az 8 punto olabilir.
			if (_fontSize_num != uint($fontSize))
			{
				_fontSize_num = (uint($fontSize) <= 8) ? 8 : uint($fontSize);
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//fontBold
		[Inspectable(type="Boolean",defaultValue=true)]
		public function get fontBold():Boolean
		{
			return _fontBold_bool;
		}
		
		public function set fontBold($value:Boolean):void
		{
			if (_fontBold_bool != $value)
			{
				_fontBold_bool = $value;
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//effect
		public function get effect():uint
		{
			return _effect_num;
		}
		
		public function set effect($effectName:uint):void
		{
			_effect_num = $effectName;
		}
		
		//antiAlias
		public function get antiAlias():uint
		{
			return _antiAlias_num;
		}
		
		public function set antiAlias($antiAliasType:uint):void
		{
			if (_antiAlias_num != $antiAliasType)
			{
				_antiAlias_num = $antiAliasType;
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//url
		[Inspectable(type="String",defaultValue="")]
		public function get url():String
		{
			return _url_str;
		}
		
		public function set url($linkAdres:String):void
		{
			_url_str = $linkAdres;
		}
		
		//urlTarget
		[Inspectable(type="String",defaultValue="_blank",enumeration="_self, _blank, _parent, _top")]
		public function get urlTarget():String
		{
			return _target_str;
		}
		
		public function set urlTarget($value:String):void
		{
			_target_str = $value;
		}
		
		//enabled
		[Inspectable(defaultValue=true)]
		override public function get enabled():Boolean
		{
			return _enabled_bool;
		}
		
		override public function set enabled($value:Boolean):void
		{
			if (_enabled_bool != $value)
			{
				_enabled_bool = $value;
				if (_enabled_bool)
				{
					if(!_toggleButton_bool) {
						frame = FRAME.UP;
					}else {
						//toggle button true ise enabled true yapıldığında toggle value değerine git.
						toggleValue = _toggleValue_bool; 
					}
				}
				else
				{
					frame = "disable";
				}
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//buttonMode
		override public function get buttonMode():Boolean
		{
			return _button_bool;
		}
		
		override public function set buttonMode($value:Boolean):void
		{
			if (_button_bool != $value)
			{
				_button_bool = $value;
				//super.buttonMode = ($value) ? useHandCursor : false;
				//olayları ekle/kaldır.
				_controlListeners(_button_bool);
			}
		}
		
		//useHandCursor
		[Inspectable(type="Boolean",defaultValue=true)]
		override public function get useHandCursor():Boolean
		{
			return _handCursor_bool;
		}
		
		override public function set useHandCursor($value:Boolean):void
		{
			if (_handCursor_bool != $value)
			{
				_handCursor_bool = $value;
			}
		}
		
		//toggleButton
		public function get toggleButton():Boolean
		{
			return _toggleButton_bool;
		}
		
		public function set toggleButton($value:Boolean):void
		{
			if (_toggleButton_bool != $value)
			{
				_toggleButton_bool = $value;
				//frame e git.
				toggleValue = _toggleValue_bool;
			}
		}
		
		//toggleValue
		public function get toggleValue():Boolean
		{
			return _toggleValue_bool;
		}
		
		public function set toggleValue($value:Boolean):void
		{
				_toggleValue_bool = $value;
				//çalıştırılırsa toggleButton true oluyor.
				if (!_toggleButton_bool) _toggleButton_bool = true;
				//button enabled ise toggle value değerine git.
				if (enabled) {
					if (_toggleValue_bool)
						_goto(FRAME.DOWN)
					else
						_goto(FRAME.UP);
					}
		}
		
		//leftIconSpace
		[Inspectable(type="Number",defaultValue=0)]
		public function get leftIconSpace():Number
		{
			return Number(_leftIconSpace_num);
		}
		
		public function set leftIconSpace($space:Number):void
		{
			if (_leftIconSpace_num != $space)
			{
				_leftIconSpace_num = uint($space);
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//rightIconSpace
		[Inspectable(type="Number",defaultValue=0)]
		public function get rightIconSpace():Number
		{
			return Number(_rightIconSpace_num);
		}
		
		public function set rightIconSpace($space:Number):void
		{
			if (_rightIconSpace_num != uint($space))
			{
				_rightIconSpace_num = uint($space);
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//topSpace
		public function get topSpace():uint
		{
			return _topSpace_num;
		}
		
		public function set topSpace($space:uint):void
		{
			if (_topSpace_num != $space)
			{
				_topSpace_num = $space;
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//leftSpace
		public function get leftSpace():uint
		{
			return _leftSpace_num;
		}
		
		public function set leftSpace($space:uint):void
		{
			if (_leftSpace_num != $space)
			{
				_leftSpace_num = $space;
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//rightSpace
		public function get rightSpace():uint
		{
			return _rightSpace_num;
		}
		
		public function set rightSpace($space:uint):void
		{
			if (_rightSpace_num != $space)
			{
				_rightSpace_num = $space;
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//bottomSpace
		public function get bottomSpace():uint
		{
			return _bottomSpace_num;
		}
		
		public function set bottomSpace($space:uint):void
		{
			if (_bottomSpace_num != $space)
			{
				_bottomSpace_num = $space;
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//labelLeftSpace
		public function get labelLeftSpace():uint
		{
			return _labelLeftSpace_num;
		}
		
		public function set labelLeftSpace($space:uint):void
		{
			if (_labelLeftSpace_num != $space)
			{
				_labelLeftSpace_num = $space;
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//labelRightSpace
		public function get labelRightSpace():uint
		{
			return _labelRightSpace_num;
		}
		
		public function set labelRightSpace($space:uint):void
		{
			if (_labelRightSpace_num != $space)
			{
				_labelRightSpace_num = $space;
				if (_autoDraw_bool)
					draw();
			}
		}
		
		//feed
		public function get feed():XMLList
		{
			return _feed_xml;
		}
		
		public function set feed($xmlSource:XMLList):void
		{
			if (_feed_xml != $xmlSource)
			{
				_feed_xml = $xmlSource;
				if (_autoDraw_bool)
					draw();
			}
		}		
		
		/*

		Olay Kontrol
		
		*/
		
		//buttonun olaylarını yönetir.
		private function _controlListeners($value:Boolean = true):void
		{
			//button aktif ise.
			if (_me != null)
				if ($value)
				{
					if (!_me.space.hasEventListener(MouseEvent.CLICK))
					{
						//olayları oluştur.
						_me.space.addEventListener(MouseEvent.CLICK, _mouseClickAction);
						_me.space.addEventListener(MouseEvent.MOUSE_OVER, _mouseOverAction);
						_me.space.addEventListener(MouseEvent.MOUSE_OUT, _mouseOutAction);
						_me.space.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownAction);
						_me.space.addEventListener(MouseEvent.MOUSE_UP, _mouseUpAction);
					}
				}
				else
				{
					if (_me.space.hasEventListener(MouseEvent.CLICK))
					{
						//olayları sil.
						_me.space.removeEventListener(MouseEvent.CLICK, _mouseClickAction);
						_me.space.removeEventListener(MouseEvent.MOUSE_OVER, _mouseOverAction);
						_me.space.removeEventListener(MouseEvent.MOUSE_OUT, _mouseOutAction);
						_me.space.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDownAction);
						_me.space.removeEventListener(MouseEvent.MOUSE_UP, _mouseUpAction);
					}
				}
		
		}
		
		//button fonksiyonları
		private function _mouseClickAction(e:MouseEvent = null):void
		{
			//eğer url değişkeni dolu ise linke git.
			if (_url_str != "")
			{
				var __request_urlRequest:URLRequest = new URLRequest(_url_str);
				try
				{
					navigateToURL(__request_urlRequest, _target_str);
				}
				catch (e:Error)
				{
					trace(e.message);
				}
			}
		}
		
		//olay fonksiyonları.
		private function _mouseOverAction(event:MouseEvent = null):void
		{
			//useHandCursor açık ise göster.
			if (_handCursor_bool) Mouse.cursor = "button";
			//toggle button basılı ise üzerine gelice hareket olmasın.
			if (!_toggleButton_bool || !_toggleValue_bool)
			{
				_frame_str = FRAME.OVER;
				_effectTo(_frame_str);
			}
			
			//ses dosyasını çalıştır.
			if (_overSound_sound != null)
				_overSound_sound.play();
		}
		
		private function _mouseOutAction(event:MouseEvent = null):void
		{
			var __changed:Boolean = false;
			
			//cursor normal olsun.
			Mouse.cursor = "auto";
			//toggle button basılı ise üzerinden ayrılınca hareket olmasın.
			if (_toggleButton_bool && _toggleValue_bool)
			{
				if (_frame_str != FRAME.DOWN)
				{
					_frame_str = FRAME.DOWN;
					__changed = true;
				}
			}
			else
			{
				if (_frame_str != FRAME.UP)
				{
					_frame_str = FRAME.UP;
					__changed = true;
				}
			}
			
			//frame değişikliği oldu.
			if (__changed)
				_effectTo(_frame_str);
		
		}
		
		private function _mouseDownAction(event:MouseEvent = null):void
		{
			_frame_str = FRAME.DOWN;
			_effectTo(_frame_str);
		}
		
		private function _mouseUpAction(event:MouseEvent = null):void
		{
			//toggle button basılı ise hareket olmasın.
			if (_toggleButton_bool)
			{
				_toggleValue_bool = !_toggleValue_bool;
			}
			
			//toggle button basılı değilken veya normal buttonken hareket var.
			if (!_toggleButton_bool || !_toggleValue_bool)
			{
				_frame_str = FRAME.OVER;
				_effectTo(_frame_str);
			}
			
			//ses dosyasını çalıştır.
			if (_downSound_sound != null)
				_downSound_sound.play();
		}
	}
}