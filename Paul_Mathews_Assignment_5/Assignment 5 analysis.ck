SndBuf s =< FFT fft =^ RollOff roff => blackhole;
adc => fft;
fft =^ Centroid cent => blackhole;
fft =^ Flux flux => blackhole;
fft =^ RMS rms => blackhole;//set up analyses

1024 => fft.size;
1024 => int WinSize;//fft parameters

Windowing.hann(WinSize) => fft.window;//windowing is nicer

.85 => roff.percent;//rolloff point

"data/08 Vesuvius.wav" => string file;
file => s.read;
.8 => s.gain;
s => dac;//set up SndBuf, may as well hear the music too

"localhost" => string hostname;
12001 => int port;
OscSend xmit;
xmit.setHost(hostname, port);//Set up OSC send

//misc variables
0 => int gate;
5 => float threshold;
now => time startTime;
startTime + s.samples()::samp => time endTime;//ready to finish when the music does

fun void oscSend(float f1, float f2, float f3, float f4)
{
    xmit.startMsg("/things", "ffff");
    f1 => xmit.addFloat;
    f2 => xmit.addFloat;
    f3 => xmit.addFloat;
    f4 => xmit.addFloat;   //sending all the analysis data
}
fun void oscSend2(int i)//sending the threshold crossing
{
    xmit.startMsg("/trigger","i");
    i => xmit.addInt;
}


while (now < endTime)
{
    //Calulate Rolloff
    roff.upchuck() @=> UAnaBlob blob;
    blob.fval(0) => float roffValue;
    //Calculate Centroid
    cent.upchuck() @=> UAnaBlob blob2;
    blob2.fval(0) => float centValue;
    //Flux
    flux.upchuck() @=> UAnaBlob blob3;
    flux.fval(0)*100 => float fluxValue;//scale to a meaningful value
    //RMS
    rms.upchuck() @=> UAnaBlob blob4;
    rms.fval(0)*1000 => float rmsValue;//scale to a meaningful value
    
    //threshold business
    if ((rmsValue > threshold) && (gate == 0))
    {
        1 => gate;
        oscSend2(gate);//send when threshold crossed up
    }
    else if ((rmsValue < threshold) && (gate == 1))
    {
        0 => gate;
        oscSend2(gate);//send when threshold crossed back down
    }
   //send
    oscSend(roffValue, centValue, fluxValue, rmsValue);
    
    WinSize::samp => now;//advance one window at a time  
    
}