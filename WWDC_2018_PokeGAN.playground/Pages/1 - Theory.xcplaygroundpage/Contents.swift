/*:
 [Previous](@previous)
 
 # A quick theory lesson
 
 ## Neural network
 To get started we'll need a short primer on neural networks.
 
 A neural network is a computer model that in some ways resemble how the human brain works. It comes in many shapes and sizes and it can learn to do various things such as discriminating objects in an picture. To learn this, the network practices repeatedly, in a process called training, on a set of labelled pictures.
 
 After a while, the network has become so proficient that given a picture it has never seen before, it can detect what objects are in it.
 
 The important thing to note here is that the neural network can't then be used in reverse. Giving it a list of objects does __not__ yield a picture in which they are contained.
 
 
 ## GAN
 Generative adversarial networks take two neural networks and make them compete. One is a generator and the other a discriminator, and they try to outsmart each other.
 
 Think of the generator as a forger and the discriminator as a detective. The forger will try to create a counterfeit without any knowledge of what the real thing looks like. The detective, knowing what the real thing looks like, has to determine whether the counterfeit can be distinguished from the real thing. These two play a game of cat-and-mouse and both get better at their respective skills.
 
 Now, consider that in this process we've been training the generator to become a master forger. This gives us a neural network that can actually generate content such as a picture.
 This is a major stepping stone. Imagine a computer making music, directing a movie or writing a book all on its own!
 
 
 [Try a GAN in Action](2%20-%20Demo)
 
*/
