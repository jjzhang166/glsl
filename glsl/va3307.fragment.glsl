
// from http://frank.bitsnbites.eu/safe.html

//update: an hybrid from #3281.0 and #3304.0 by nikoclass

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float gc=fract(time*3.2/3.),
gb=fract(gc*2.),
PI=3.14159;
vec3 ff(vec2 p){
    vec2 q=vec2(sin(.08*p.x),4.*p.y);
    vec3 c=vec3(0);
    for(float i=0.;i<10.;i++)
      c+=(1.+sin(i*sin(time)+vec3(0.,1.3,2.2)))*.2/length(q-vec2(sin(i),12.*sin(.3*time+i)));
    return c+vec3(mix(mod(floor(p.x*.2)+floor(p.y*2.2),2.),.2,gc));
}
vec3 ft(vec3 o,vec3 d){
    d.y*=.65+.1*sin(.5*time);
    float D=1./(d.y*d.y+d.z*d.z),
          a=(o.y*d.y+o.z*d.z)*D,
          b=(o.y*o.y+o.z*o.z-36.)*D,
          t=-a-sqrt(a*a-b);
    o+=t*d;
    return ff(vec2(o.x,atan(o.y,o.z)))*(1.+.01*t);
}

float heightmap(vec2 position)
{
	float height = 0.0;
	
	height = sin(position.x*0.0625);
	height = clamp(height,0.0,0.5);
	height += clamp(sin(position.y*0.0625),0.0,1.0);
	height = clamp(height,0.0,0.5);
	height = 1.0 - height;
	vec2 lx = sin(position.xy*0.015);
	vec2 x = vec2(sqrt(lx.x*lx.x+lx.y*lx.y),atan(lx.y,lx.x));
	
	float groove1 = sin(x.y * 50. - PI * .5) + cos(x.y * 50. + PI);
	float groove2 = sin(x.x * 50. - PI * .5) + cos(x.x * 50. + PI);
	float groove = 1.-max(max(groove1, groove2)-1.,0.) * .2;
	float dots = max(sin(position.x * .5 + PI * .5) + cos(position.y * .5 - PI *2.), 1.) - 1.;
	
	height = min(height, groove);
	
	height = max(height, dots*.25 + .5);
	
	return height;
}

vec2 normal(vec2 p) {
	float e = 0.1;
	vec2 vx = vec2(e, 0.0);
	vec2 vy = vec2(0.0, e);
	float dx = (heightmap(p + vx) - heightmap(p - vx))/e/2.0;
	float dy = (heightmap(p + vy) - heightmap(p - vy))/e/2.0;
	return vec2(dx, dy);
}
void main(){
    vec2 p=(2.*gl_FragCoord.xy-resolution)/resolution.y,
         q=2.*gl_FragCoord.xy/resolution-1.;
	
    p += normal(p * 200.0);
	
    vec3 cp=vec3(-time*20.+1.,1.6*sin(time*1.2),2.+2.*cos(time*.3)),
         ct=cp+vec3(1.,.3*cos(time),-.2),
         cd=normalize(ct-cp),
         cr=normalize(cross(cd,vec3(.5*cos(.3*time),0.,1.))),
         cu=cross(cr,cd),
         rd=normalize(2.*cd+cr*p.x+cu*p.y),
         c=ft(cp,rd)*
           min(1.,1.8-dot(q,q))*(.9+.1*sin(3.*sin(gc)*gl_FragCoord.y));
    gl_FragColor=vec4(c,1);
}