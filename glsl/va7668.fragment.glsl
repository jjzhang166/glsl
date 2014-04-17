#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159265358979323846264

float hash( float n ) { return fract(sin(n)*43758.5453123); }

float snoise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    return mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
               mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y)*2.-1.;
}


//mattdesl - devmatt.wordpress.com - textured planet by Matt DesLauriers

float clouds( vec2 coord ) {
	//standard fractal
	coord *= 2.;
	float n = snoise(coord);
	n += 0.5 * snoise(coord * 2.0);
	n += 0.25 * snoise(coord * 4.0);
	n += 0.125 * snoise(coord * 8.0);
	n += 0.0625 * snoise(coord * 16.0);
	n += 0.03125 * snoise(coord * 32.0);
	n += 0.03125 * snoise(coord * 32.0);
	return n;
}

void main( void ) {	
	vec2 norm = 2.0 * gl_FragCoord.xy / resolution.xy - 1.0;
	norm.x *= resolution.x / resolution.y;
	
	float r = length(norm);
	float phi = atan(norm.y, norm.x);
	
	//spherize
	r = 2.0 * asin(r) / PI;
	
	//bulge a bit
	//r = pow(r, 1.5);
	
	//zoom in a bit
	//r /= 1.25;
	
	vec2 coord = vec2(r * cos(phi), r * sin(phi));
	coord = coord/2.0 + 0.5;

	coord.x += time*0.03;
	coord.y += time*0.009;
	float n = clouds(coord*3.0);
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) - 0.5;
	position.x *= resolution.x / resolution.y;
	float len = length(position);
		
	float terrain = smoothstep(0.1, 0.0, n); //block out some terrain
	
	vec3 terrainColor = vec3(76./255., 147./255., 65.0/255.); //green
	
	terrainColor = mix(vec3(131.0/255., 111.0/255., 39./255.), terrainColor, smoothstep(0.2, .7, 1.0-n));
	
	//mix in brown edge
	terrainColor = mix(vec3(94.0/255., 67.0/255., 31./255.), terrainColor, smoothstep(0.0, 0.18, n));
	terrainColor += n*0.3;
	
	
	//n *= sin(coord.y*sin(coord.x)*2.0);

	
	
	
	
	vec3 color = vec3(81.0/255.0, 121.0/255.0, 181.0/255.); //water
	color -= (1.0-n*4.0)*0.03;
	color = mix(terrainColor, color, terrain); //mix terrain with water
	
	
	color *= smoothstep(0.5, 0.495, len);
	color *= smoothstep(0.65, .32, len);
	
	vec3 glow = vec3(smoothstep(0.57, 0.3, len)) * vec3(0.6, 0.8, 1.5);
	
	color = clamp(color, 0.0, 1.0);
	color.r = max(0.0, color.r);
	color.g = max(0.0, color.g);
	color.b = max(0.0, color.b);
	color += glow * smoothstep(0.495, 0.5, len);
	
	gl_FragColor = vec4( color, 1.0 );

}
