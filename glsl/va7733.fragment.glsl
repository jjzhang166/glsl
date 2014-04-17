#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14

float 
minChannel(in vec3 v)
{
  float t = (v.x<v.y) ? v.x : v.y;
  t = (t<v.z) ? t : v.z;
  return t;
}

float 
maxChannel(in vec3 v)
{
  float t = (v.x>v.y) ? v.x : v.y;
  t = (t>v.z) ? t : v.z;
  return t;
}

vec3 
rgbToHsv(in vec3 rgb)
{
  vec3  hsv = vec3(0.0);
  float minVal = minChannel(rgb);
  float maxVal = maxChannel(rgb);
  float delta = maxVal - minVal;

  hsv.z = maxVal;

  if (delta != 0.0) {
    hsv.y = delta / maxVal;
    vec3 delRGB;
    delRGB = (((vec3(maxVal) - rgb) / 6.0) + (delta/2.0)) / delta;

    if (rgb.x == maxVal) {
      hsv.x = delRGB.z - delRGB.y;
    } else if (rgb.y == maxVal) {
      hsv.x = ( 1.0/3.0) + delRGB.x - delRGB.z;
    } else if (rgb.z == maxVal) {
      hsv.x = ( 2.0/3.0) + delRGB.y - delRGB.x;
    }

    if ( hsv.x < 0.0 ) { 
      hsv.x += 1.0; 
    }
    if ( hsv.x > 1.0 ) { 
      hsv.x -= 1.0; 
    }
  }
  return hsv;
}

vec3 
hsvToRgb(in vec3 hsv)
{
  vec3 rgb = vec3(hsv.z);
  if ( hsv.y != 0.0 ) {
    float var_h = hsv.x * 6.0;
    float var_i = floor(var_h);   // Or ... var_i = floor( var_h )
    float var_1 = hsv.z * (1.0 - hsv.y);
    float var_2 = hsv.z * (1.0 - hsv.y * (var_h-var_i));
    float var_3 = hsv.z * (1.0 - hsv.y * (1.0 - (var_h-var_i)));

    int i = int(var_i);
    if (i==0)
	rgb = vec3(hsv.z, var_3, var_1); 
    else if (i==1)
	rgb = vec3(var_2, hsv.z, var_1); 
    else if (i==2)
	rgb = vec3(var_1, hsv.z, var_3);
    else if (i==3)
	rgb = vec3(var_1, var_2, hsv.z); 
    else if (i==4)
	rgb = vec3(var_3, var_1, hsv.z); 
    else
	rgb = vec3(hsv.z, var_1, var_2); 
  }
  return rgb;
}

void main( void ) {

	vec2 norm = 2.0 * gl_FragCoord.xy / resolution.xy - 1.0;
	norm.x *= resolution.x / resolution.y;
	
	norm *= 2.5*(sin(time*.5)/2.+.5);
	
	float r = length(norm);
	float phi = atan(norm.y, norm.x) + 3.1415927;
	
	//spherize
	r = 2.0 * asin(r) / PI;
	r += (sin(time)/4.-.5);
	
	//zoom out a bit
	r /= 0.5;
	
	vec2 coord = vec2(r * cos(phi), r * sin(phi));
	coord = coord/2.0 + 0.5;
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	position.x *= resolution.x/resolution.y;
	
	float len = length(position);
	
	float pattern = 0.0;
	pattern += sin(coord.x*50.0)*5.5;
	pattern *= sin(coord.y*50.0)*5.5;
	
	
	//pattern += sin(coord.x*coord.y);
	
	pattern = clamp(pattern, 0.0, 1.0);
	
	vec3 rgb = hsvToRgb(vec3((r+pattern), pattern, phi/pattern)); 
	
	vec3 col = vec3(rgb);
//	col *= smoothstep(0.5, 0.498, len);
	
	gl_FragColor = vec4(col, 1.0);

}