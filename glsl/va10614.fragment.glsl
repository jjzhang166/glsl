#ifdef GL_ES
precision highp float;
#endif

#define eps 0.05

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float line(vec2 p, float k, float d);            
float circle(vec2 p, vec2 t, float r);
float hash(vec2 co);
float noise(vec2 p, float s);
float mix2(float a2, float b2, float t2);
float fractnoise(vec2 p, float s, float c);
vec2 blockMod(vec2 uv, float modulus);
void fractnoiseGradient(vec2 p, float s, float c, out float sdf, out vec2 n);

struct sdObject{
	float sdf;  	//signed distance field
	float boundary; //phi
	float surface;	//> phi
	float mask; 	//mask
	vec2 n;     	//normal
};

	
void createField(out sdObject o, vec2 p, float s, float c, float m){
	fractnoiseGradient(p, s, c, o.sdf, o.n);
	
	o.sdf  		= clamp(o.sdf*p.y, 0., 1.);
	o.mask 		= clamp(smoothstep(1., m, p.y+o.sdf), 0., 1.);
	o.surface  	= clamp(o.sdf * 1.-o.mask, 0., 1.);
	o.boundary  	= clamp(smoothstep(eps, m-o.mask, o.mask), 0., 1.);
	o.n    		= .5 + normalize(o.n) * .5;
	
	vec3 bn = vec3(o.n.x, o.sdf, o.n.y);
}

void main() 
{
	vec2 p = (gl_FragCoord.xy / resolution.x) * 2.0 - vec2(1.0, resolution.y / resolution.x);
	vec2 m = (mouse) * 2.0 - vec2(1.0, resolution.y / resolution.x);
	
	//Foreground
	vec2 pt = vec2(p.x+time*.2, p.y+.5);
	float s = .5;
	float c = .5;
	sdObject terrain;
	createField(terrain, pt, s, c, .97);
	
	s = .1;
	c = hash(vec2(blockMod(vec2(pt.x*terrain.surface, 1.), 4096.).x, .5));
	sdObject groundTex;
	createField(groundTex, pt, s, c, .99);
	groundTex.surface += terrain.surface;
	
	s = 32.+terrain.sdf*.01;
	c = hash(vec2(blockMod(pt, 2.).x, 0.));
	sdObject sandTex;
	createField(sandTex, pt, s, c*.03, .05);
	
	s = 32.+terrain.sdf*.01;
	c = hash(vec2(blockMod(pt, 2.5).x, 0.));
	sdObject grass;
	createField(grass, pt-.25, s, .5+c, .05);
	grass.surface += terrain.surface;
	//

	//FG
	vec2 pf = vec2(p.x+time*.23-p.y*.1, p.y+.55);
	s = 1.95;
	c = .19;
	sdObject fgTerrain;
	createField(fgTerrain, pf, s, c, .97);
	//
	
	//BG
	vec2 pm = vec2(p.x+time*.09-p.y*.1, p.y+.25);
	s = 1.95;
	c = .19;
	sdObject bgTerrain;
	createField(bgTerrain, pm, s, c, .97);
	//

	vec3 fgColor = vec3(.25, .5, .25);
	vec3 fgResult = fgTerrain.surface + fgColor;
	float lt = (terrain.mask*float(p.x<.01));
	float rt = (terrain.surface*float(p.x>.02));
	
	
	vec3 tColor = vec3(.5, .25, .25);
	vec3 tResult = terrain.surface + tColor;
	tResult -= fgTerrain.mask;
	
	vec3 bgColor = vec3(.25, .25, .5);
	vec3 bgResult = bgTerrain.surface * terrain.mask + bgColor;
	bgResult -= terrain.mask;
	
	gl_FragColor = vec4(lt+rt);
	//wip
}


float line(vec2 p, float k, float d)
{
	return p.y - k*p.x+d;
}
            
float circle(vec2 p, vec2 t, float r)
{
	return length(p-t) - r;
}

float hash(vec2 co)
{
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p, float s){
	return fract(956.9*cos(429.9*dot(vec3(p,s),vec3(9.7,7.5,11.3))));
}
 
float mix2(float a2, float b2, float t2)
{
	return mix(a2,b2,t2*t2*(3.-2.*t2)); 
}
	
float fractnoise(vec2 p, float s, float c){
	float sum = .0;
	for(float i=0. ;i<6.; i+=1.){
        
		vec2 pi = vec2(pow(2.,i+c));
		vec2 posPi = p*pi;
		vec2 fp = fract(posPi);
		vec2 ip = floor(posPi);
	
		float n0 = noise(ip, s);
		float n1 = noise(ip+vec2(1.,.0), s);
		float n3 = noise(ip+vec2(.0,1.), s);
		float n4 = noise(ip+vec2(1.,1.), s);
		
		float m0 = mix2(n0,n1, fp.x);	
		float m1 = mix2(n3,n4, fp.x);
		float m3 = mix2(m0, m1, fp.y);
		
        	sum += 2.0*pow(.5,i+c)*m3;
	}
	
	return sum*(2.2-c);
}

vec2 blockMod(vec2 uv, float modulus){
	return vec2(uv.x - mod(uv.x, modulus/resolution.x), uv.y - mod(uv.y, modulus/resolution.y));;
}

void fractnoiseGradient(vec2 p, float s, float c, out float sdf, out vec2 n)
{
	vec2 px = vec2(p.x + eps, p.y);	
	vec2 py = vec2(p.x, p.y + eps);
	
	sdf = fractnoise(p, s, c);
	float sdfx = fractnoise(px, s, c);
	float sdfy = fractnoise(py, s, c);

	n = (vec2(sdf, sdf) - vec2(sdfx, sdfy))/eps;
}


//sphinx + rianflo