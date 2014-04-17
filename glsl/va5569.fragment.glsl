#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float hash( float n ) { return fract(sin(n)*43758.5453); }

float noise( in vec2 x )
{
	vec2 p = floor(x);
	vec2 f = fract(x);
    	f = f*f*(3.0-2.0*f);
    	float n = p.x + p.y*57.0;
    	float res = mix(mix(hash(n+0.0), hash(n+1.0),f.x), mix(hash(n+57.0), hash(n+58.0),f.x),f.y);
    	return res;
}

float getHeight(vec2 p)
{
   p += vec2(time*0.2, time*0.3);
   float n = noise(p*1.0) * noise(p.yx*1.3) + noise(p*2.1) * noise(p.yx*0.7);
   n = clamp(n*5.0-2.5, 0.0, 1.0);// + max(0.0, sin(p.x*2.0+time) * cos(p.y*2.0))*2.0;
   return n;	
}

#define NORMAL_RANGE	0.1
#define NORMAL_BLUR_RANGE   0.035

vec3 getNormal2(vec2 p)
{
   float difX = getHeight(p+vec2(-NORMAL_RANGE, 0.0)) - getHeight(p+vec2(NORMAL_RANGE, 0.0));
   float difY = getHeight(p+vec2(0.0, -NORMAL_RANGE)) - getHeight(p+vec2(0.0, NORMAL_RANGE));
   vec3 d1 = normalize(vec3(NORMAL_RANGE*2.0, 0.0, -difX));
   vec3 d2 = normalize(vec3(0.0, NORMAL_RANGE*2.0, -difY));
   vec3 d3 = cross(d1, d2);
   //if( d3.z < 0.0 )
   //   d3 = -d3;
   return d3;
}

//#define HQ_NORMALS	1

vec3 getNormal(vec2 p)
{
   #ifdef HQ_NORMALS
   vec3 normal = getNormal2(p-vec2(NORMAL_BLUR_RANGE,0.0));
   normal += getNormal2(p+vec2(NORMAL_BLUR_RANGE,0.0));
   normal += getNormal2(p-vec2(0.0,NORMAL_BLUR_RANGE));
   normal += getNormal2(p+vec2(0.0,NORMAL_BLUR_RANGE));
   return normalize(normal);
   #else
   return getNormal2(p);
   #endif
}

void main( void ) {

	vec2 position = ( (gl_FragCoord.xy - resolution*0.5) / resolution.yy ); // resolution scale while maintaining aspect ratio
	position *= 20.0; // zoom
	
	// parameters
	vec3 _lightPosition = vec3(0.0 + sin(time)*100.0, sin(time*0.3)*100.0, 100.0);
	vec3 _viewerPosition = vec3(0.0, 0.0, 10.0); 
	float pixelSpecularGlossiness = 0.5;
	float pixelSpecularConstant = 1.0;
	float height = getHeight(position);
	vec3 worldPosition = vec3(position.xy, height);
	
	
	
	vec3 viewVector = normalize(_viewerPosition - worldPosition);
	vec3 lightVector = _lightPosition - worldPosition;
	float lightDistance = length(lightVector);
	lightVector = normalize(lightVector);
	vec3 halfVector = normalize(lightVector + viewVector);

	vec3 pixelNormal = getNormal(position);

	// calulate useful vectors
	float dotNL = clamp( dot( pixelNormal, lightVector ), 0.0, 1.0);
	float dotNH = clamp( dot( pixelNormal, halfVector ), 0.0, 1.0);
	float dotNV = clamp( dot( pixelNormal, viewVector ), 0.0, 1.0);
	float dotLH = clamp( dot( lightVector, halfVector ), 0.0, 1.0);
	// calculate specular
	vec3 _light_specularColor = vec3(1.0, 1.0, 1.0);
	float _light_specularPower = 10.0;
	float lightSpecularE = pow(2.0, 12.0 * pixelSpecularGlossiness);
	float D = pow(dotNH, lightSpecularE ) * ( lightSpecularE + 1.0 ) / 2.0;
	float lightIrradianceSpecular = min(_light_specularPower / lightDistance, 1.0);
	vec3 lightSpecular = (pixelSpecularConstant * _light_specularColor) * (D / ( 4.0 * pow( dotLH, 3.0 ) ) * dotNL) * lightIrradianceSpecular;
	
	
	
	float color = 0.5;
	vec4 light = vec4(color, color, color, 0.0) * max(0.0, dot(pixelNormal, lightVector)); // diffuse light color
	gl_FragColor = light + vec4(lightSpecular, 0.0);
	//gl_FragColor = vec4(pixelNormal, 0.0); // visualize normals

}