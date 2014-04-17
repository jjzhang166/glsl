//simply metaballs by uggway
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
float sw = resolution.x/2.0, sh = resolution.y/2.0;
float r = resolution.x/200.;
float mbsize[5];
    mbsize[0]=r*100.;
	mbsize[1]=r*200.;
	mbsize[2]=r*300.;
	mbsize[3]=r*400.;
	mbsize[4]=r*500.;
float c=cos(time), s=sin(time);	
vec2 mbpos[5];
vec2 pos = gl_FragCoord.xy;
	r *=20.;
mbpos[0] = vec2(c * r + sw, -s * r + sh);
mbpos[1] = vec2(-c * r/2. + sw, s * r + sh);
mbpos[2] = vec2(c * r*2. + sw, s * r/2. + sh);
mbpos[3] = vec2(-c * r*1.5 + sw, -sin(time * 0.25) * r*1.5 + sh);
mbpos[4] = vec2(-cos(time * 0.33) * r*3. + sw, sin(time * 1.5) * r*2. + sh);

 float dist = 0.0;
 for(int i=0; i<5; i++)
    dist += mbsize[i]/pow(distance(pos.xy, mbpos[i]),2.0);
  gl_FragColor = vec4(1.0-dist,dist,1.0-dist,1.0);

}
