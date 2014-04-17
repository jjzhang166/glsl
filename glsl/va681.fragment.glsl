#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float s = 1.05;			//specular
vec3 sc = vec3(.3,.3,.3);	//specular color
float kd = .5;			//diffuse
vec3 dc = vec3(1.,.1,.1);	//diffuse color
float ka = .2;			//ambient
vec3 ac = vec3(.6,.1,.25);	//ambient color
float shine = 10.;		//shine


void main( void ) {

	vec2 position = (gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x); 
    
  	float dx=position.x;
  	float dy=position.y;
  	float scale=.25;
  	scale = 1./scale;
  
  
  	vec3 n = vec3(dx*scale, dy*scale, sqrt(dx*dx+dy*dy)*scale-1.);
  	n = normalize(n);
    
  	vec3 light = vec3(cos(time*.5)*1000., sin(time)*500., sin(time*.5)*1000.)-n;
  	light = normalize(light);
  
  	vec3 reflection = reflect(-light, n);

  	vec3 view = vec3(0.,0.,-3.)-n;
  	view = normalize(view);  	
  	
  	vec3 color = vec3(0.,0.,0.);
  
  	//ambient
  	color += ac*ka;
  
  	if (n.z<0.) //clipping
        {
  		//defuse
          	float diffuseLight = max(dot(light,n), 0.0);
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