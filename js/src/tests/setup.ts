import { setCryptoImplementation } from '@joclaim/tls'
import { webcryptoCrypto } from '@joclaim/tls/webcrypto'

setCryptoImplementation(webcryptoCrypto)