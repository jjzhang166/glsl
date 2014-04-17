#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// algorithm from http://www.easyrgb.com/index.php?X=MATH&H=19#text19

float Hue_2_RGB( float v1, float v2, float vH )             //Function Hue_2_RGB
{
   if ( vH < 0. ) vH += 1.;
   if ( vH > 1. ) vH -= 1.;
   if ( ( 6. * vH ) < 1. ) return ( v1 + ( v2 - v1 ) * 6. * vH );
   if ( ( 2. * vH ) < 1. ) return ( v2 );
   if ( ( 3. * vH ) < 2. ) return ( v1 + ( v2 - v1 ) * ( ( 2. / 3. ) - vH ) * 6. );
   return ( v1 );
}

vec3 hsl2rgb(vec3 hsl){
	vec3 rgb = vec3(0.);
	if ( hsl.y == 0. )                       //HSL from 0 to 1
	{
	   rgb.x = hsl.x * 255.;                      //RGB results from 0 to 255
	   rgb.y = hsl.x * 255.;
	   rgb.z = hsl.x * 255.;
	}
	else
	{
	   float var_2 = 0.;
	   if ( hsl.z < 0.5 ) var_2 = hsl.z * ( 1. + hsl.y );
	   else           var_2 = ( hsl.z + hsl.y ) - ( hsl.y * hsl.z );
	
	   float var_1 = 2. * hsl.z - var_2;

	   rgb.x = 255. * Hue_2_RGB( var_1, var_2, hsl.x + ( 1. / 3. ) );
	   rgb.y = 255. * Hue_2_RGB( var_1, var_2, hsl.x );
	   rgb.z = 255. * Hue_2_RGB( var_1, var_2, hsl.x - ( 1. / 3. ) );
	}
	return rgb;
}

void main( void ) {

	vec2 uv = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	gl_FragColor.xyz = hsl2rgb( vec3(1., 1., uv.x));
	gl_FragColor = vec4(.0 );

}