#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float PI=3.14159265;

float s = 1.05;			//specular
vec3 sc = vec3(.3,.3,.3);	//specular color
float kd = .5;			//diffuse
vec3 dc = vec3(1.0,1.0,0.0);	//diffuse color
float ka = .2;			//ambient
vec3 ac = vec3(.6,.1,.25);	//ambient color
float shine = 10.;		//shine

float segm( float a, float b, float c, float x )
{
    return smoothstep(a-c,a,x) - smoothstep(b,b+c,x);
}


vec3 sun( float x, float y )
{
    //float a = atan(x,y);
    float r = sqrt(x*x+y*y);

    //float s = 0.5 + 0.5*sin(a*17.0+1.5*time);
    float d = 0.5 + 0.2*pow(s,-30.0);
    float h = r/d;
    float f = 3.0-smoothstep(0.92,1.0,h);

    float b = pow(0.5 + 0.5*sin(3.0*time),500.0);
    vec2 e = vec2( abs(x)-0.15,(y-0.1)*(1.0+10.0*b) );
    float g = 1.0 - (segm(0.06,0.09,0.01,length(e)))*step(0.0,e.y);

    float t = 0.5 + 0.5*sin(12.0*time);
    vec2 m = vec2( x, (y+0.15)*(1.0+10.0*t) );
    g *= 1.0 - (segm(0.06,0.09,0.01,length(m)));

    return mix(vec3(1.0),vec3(0.9,0.8,0.0)*g,f);
}

void main( void ) {
	
	vec2 position = (gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x); 
	
	vec3 color = vec3(0.,0.,0.);
	
	color += sun( +2.0*position.x, +0.4+2.0*position.y );
	
	float dx=position.x;
  	float dy=position.y+0.2;
  	float scale=.25;
  	scale = 1./scale;
	  
  	vec3 n = vec3(dx*scale, dy*scale, sqrt(dx*dx+dy*dy)*scale-1.);
  	n = normalize(n);
    
  	vec3 light = vec3(cos(time*.5)*1000., sin(time)*500., sin(time*.5)*1000.)-n;
  	light = normalize(light);
  
  	vec3 reflection = reflect(-light, n);

  	vec3 view = vec3(0.,0.,-3.)-n;
  	view = normalize(view);   	
  	
  
  	//ambient
  	color += ac*ka; 	
	
	
  	if (n.z<0.) //clipping
        {
  		//defuse
          	float diffuseLight = 1.0;
          	dc *= kd * diffuseLight;
          	color += dc;
          
  		//specular
          	if (diffuseLight>0.)
                { 
	               	float specularLight = pow(max(dot(reflection, view), 0.0),shine);
                	sc *= s * specularLight;
                  	color += sc;
                }
	}	    
	
	  
	//gl_FragColor = vec4( n, 1.0 );
	gl_FragColor = vec4( color, 1.0 );

}